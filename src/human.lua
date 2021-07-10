Human = {battle = {}}

-- TODO: try to remove some dot operators to reclaim tokens
-- TODO: merge `radius:update` into `move` and `attack`
-- TODO: figure out how to handle enemy-unit radii edge-case above
-- TODO: use bit masks to query unit state, and simplify this nesting
-- TODO: deprecate `idx`
function Human.battle.update(state, inputs)
  -- reclaim tokens
  local yes, no = inputs.yes, inputs.no
  local cur, player, units = state.player.cursor, state.player,
                             state.stage.units

  -- determine whether a unit is beneath the cursor
  -- TODO: deprecate `idx`
  local unitHov, idx = Units.at(cur.cellx, cur.celly, units)

  -- if there is a unit beneath the cursor...
  if unitHov then
    -- is the unit a friend?
    local friend = unitHov.player == player.num

    -- ... and the unit is a friend...
    if friend then
      --- ...and is active but not selected, then select it
      if unitHov.active and not unitHov.selected then
        Info:set('select', '', unitHov)
        if yes:once() then
          if cur.unitSel then cur.unitSel:unselect() end
          cur.unitSel = unitHov
          cur.unitSel:select()

          -- TODO: move into `select` logic
          unitHov.radius:update(unitHov, state, player.num)
        end

        -- ... and is selected ...
      elseif cur.unitSel and cur.unitSel.selected and not unitHov.attacked then

        -- ... and has not acted, then open the balance menu
        if unitHov.active and not unitHov.moved then
          Info:set('balance', 'unselect', unitHov)
          if yes:once() then
            Menus.Balance:open(cur.unitSel, idx, state)
          end

          -- ... and has moved but not attacked, allow an undo move
        elseif unitHov.moved then
          Info:set('end turn', 'cancel', unitHov)
          if yes:once() then
            Menus.TurnEnd:open(state)
          elseif no:once() then
            cur.unitSel:unmove(state)

            -- refresh all units on this unit's team
            for _, u in pairs(units) do
              if u.player == unitHov.player then
                u.active, u.moved = true, false
              end
            end

            Seq:enqueue(
              {Anim.trans(cur.unitSel, cur.unitSel.cellx, cur.unitSel.celly)}
            )
          end
        end
      end

      -- ... and the unit is not a friend ...
    elseif not friend then

      -- ... and if no friendly unit has been selected ...
      if not cur.unitSel then

        -- ... and the enemy's radii are invisible, then show the radii
        if unitHov.radius.vis == false then
          Info:set('view radii', '', unitHov)
          if yes:once() then
            -- increase the unit rotation speed
            unitHov.step = 0.005
            -- draw the radii for the enemy player
            unitHov.radius:update(unitHov, state, player.num == 2 and 1 or 2)
          end

          -- ... and the enemy's radii are visible, then hide the radii
        elseif unitHov.radius.vis == true then
          Info:set('hide radii', '', unitHov)

          -- NB: we're cheating a bit here, because we don't `:select` enemy
          -- units. That being this case, we can use `:unselect` to reset the
          -- rotation speed and hide the radius.
          if yes:once() or no:once() then unitHov:unselect() end
        end

        -- ... and if a friendly unit has been selected, and is active
      elseif cur.unitSel and cur.unitSel.active then

        -- if the enemy unit is within the selected unit's attack radius, then attack
        if cur.unitSel.radius:contains('atk', unitHov.cellx, unitHov.celly) and
          not cur.unitSel.attacked then
          Info:set('attack', 'unselect', unitHov)
          if yes:once() then Menus.Target:open(unitHov, state) end

          -- if the enemy unit is within the selected unit's danger radius, then automatically move and attack
        elseif cur.unitSel.radius:contains('dng', unitHov.cellx, unitHov.celly) and
          not cur.unitSel.attacked and not cur.unitSel.moved then
          Info:set('attack', 'unselect', unitHov)
          if yes:once() then
            -- find a cell from which the attacker may attack the target
            -- TODO: sort by best defense iff token space is available
            local vantage = Radius.vantage(cur.unitSel, unitHov, state)
            local cell = vantage:rand('atk', state)

            -- move the unit
            cur.unitSel:move(cell.x, cell.y)
            cur.unitSel.radius:update(cur.unitSel, state, player.num)

            -- deactivate all *other* units belonging to the player
            Units.deactivate(units, player.num)
            cur.unitSel.active = true

            -- enqueue animations
            Seq:enqueue(
              {
                Anim.trans(cur.unitSel, cell.x, cell.y),
                function()
                  Menus.Target:open(unitHov, state)
                end,
              }
            )
          end
        end
      end
    end

    -- if there is no unit is beneath the cursor...
  elseif not unitHov then

    -- ... but an active, friendly unit has been selected, then move the
    -- friendly unit
    if cur.unitSel and cur.unitSel.active and not cur.unitSel.moved and
      Cell.open(cur.cellx, cur.celly, state) and
      cur.unitSel.radius:contains('mov', cur.cellx, cur.celly) then
      Info:set('move', 'unselect')

      if yes:once() then
        -- move the unit
        cur.unitSel:move(cur.cellx, cur.celly)

        -- deactivate all *other* units belonging to the player
        Units.deactivate(units, player.num)
        cur.unitSel.active = true

        -- enqueue animations
        Seq:enqueue({Anim.trans(cur.unitSel, cur.cellx, cur.celly)})

        -- end the player's turn if the unit is exhausted
        if cur.unitSel.attacked or cur.unitSel.stat.atk == 0 or
          cur.unitSel.stat.rng == 0 then
          player:turnEnd(state)
          -- otherwise, show the attack radius
        else
          cur.unitSel.radius:update(cur.unitSel, state, player.num)
        end
      end

      -- ... but no unit has been selected, then show the "end turn" menu
    elseif not cur.unitSel then
      Info:set('end turn', 'end turn')
      if yes:once() then Menus.TurnEnd:open(state) end
    end
  end

  -- "Z"
  if no:once() then
    -- if a unit is selected, unselect it
    if cur.unitSel then
      -- unselect the unit if it is ours
      cur.unitSel:unselect()
      cur.unitSel = nil
      -- show the "end turn" menu
    else
      Menus.TurnEnd:open(state)
    end
  end
end

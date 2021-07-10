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
  local unit, idx = Units.at(cur.cellx, cur.celly, units)

  -- if there is a unit beneath the cursor...
  if unit then
    -- is the unit a friend?
    local friend = unit.player == player.num

    -- ... and the unit is a friend...
    if friend then
      --- ...and is active but not selected, then select it
      if unit.active and not unit.selected then
        Info:set('select', '', unit)
        if yes:once() then
          if cur.unitSel then cur.unitSel:unselect() end
          cur.unitSel = unit
          cur.unitSel:select()

          -- TODO: move into `select` logic
          unit.radius:update(unit, state, player.num)
          return
        end

        -- ... and is selected ...
      elseif cur.unitSel and cur.unitSel.selected then

        -- ... and has not acted, then open the balance menu
        if not unit.moved and not unit.attacked and unit.active then
          Info:set('balance', 'unselect', unit)
          if yes:once() then
            Menus.Balance:open(cur.unitSel, idx, state)
            return
          end

          -- ... and has moved but not attacked, allow an undo move
        elseif unit.moved and not unit.attacked then
          Info:set('end turn', 'cancel', unit)
          if yes:once() then
            Menus.TurnEnd:open(state)
            return
          end
          if no:once() then
            cur.unitSel:unmove(state)

            -- refresh all units on this unit's team
            for _, u in pairs(units) do
              if u.player == unit.player then
                u.active, u.moved = true, false
              end
            end

            Seq:enqueue(
              {
                Anim.trans(cur.unitSel, cur.unitSel.cellx, cur.unitSel.celly),
                function()
                  cur.unitSel = nil
                end,
              }
            )
            return
          end
        end
      end

      -- ... and the unit is not a friend ...
    elseif not friend then

      -- ... and if no friendly unit has been selected ...
      if not cur.unitSel then

        -- ... and the enemy's radii are invisible, then show the radii
        if unit.radius.vis == false then
          Info:set('view radii', '', unit)
          if yes:once() then
            -- increase the unit rotation speed
            unit.step = 0.005
            -- draw the radii for the enemy player
            unit.radius:update(unit, state, player.num == 2 and 1 or 2)
            return
          end

          -- ... and the enemy's radii are visible, then hide the radii
        elseif unit.radius.vis == true then
          Info:set('hide radii', '', unit)
          if yes:once() or no:once() then
            -- decrease the unit rotation speed
            unit.step = 0.001
            unit.radius.vis = false
            return
          end
        end

        -- ... and if a friendly unit has been selected, and is active
      elseif cur.unitSel and cur.unitSel.active then

        -- if the enemy unit is within the selected unit's attack radius, then attack
        if cur.unitSel.radius:contains('atk', unit.cellx, unit.celly) and
          not cur.unitSel.attacked then
          Info:set('attack', 'unselect', unit)
          if yes:once() then
            Menus.Target:open(unit, state)
            return
          end

          -- if the enemy unit is within the selected unit's danger radius, then automatically move and attack
        elseif cur.unitSel.radius:contains('dng', unit.cellx, unit.celly) and
          not cur.unitSel.attacked and not cur.unitSel.moved then
          Info:set('attack', 'unselect', unit)
          if yes:once() then
            -- find a cell from which the attacker may attack the target
            -- TODO: sort by best defense iff token space is available
            local vantage = Radius.vantage(cur.unitSel, unit, state)
            local cell = vantage:rand('atk', state)

            -- move the unit
            cur.unitSel:move(cell.x, cell.y)
            cur.unitSel.radius:update(cur.unitSel, state, player.num)

            -- deactivate all *other* units belonging to the player
            Units.deactivate(units, player.num)
            cur.unitSel:activate()

            -- enqueue animations
            Seq:enqueue(
              {
                Anim.trans(cur.unitSel, cell.x, cell.y),
                function()
                  Menus.Target:open(unit, state)
                end,
              }
            )

            return
          end
        end
      end
    end

    -- if there is no unit is beneath the cursor...
  elseif not unit then

    -- ... but an active, friendly unit has been selected, then move the
    -- friendly unit
    if cur.unitSel and cur.unitSel.active and not cur.unitSel.moved and
      Cell.open(cur.cellx, cur.celly, state) and
      cur.unitSel.radius:contains('mov', cur.cellx, cur.celly) then
      Info:set('move', 'unselect')

      if yes:once() then
        -- move the unit
        cur.unitSel:move(cur.cellx, cur.celly)
        cur.unitSel.radius.vis = false
        cur.unitSel.step = 0.001

        -- deactivate all *other* units belonging to the player
        Units.deactivate(units, player.num)
        cur.unitSel:activate()

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
        return
      end

      -- ... but no unit has been selected, then show the "end turn" menu
    elseif not cur.unitSel then
      Info:set('end turn', 'end turn')
      if yes:once() then
        Menus.TurnEnd:open(state)
        return
      end
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
    return
  end
end

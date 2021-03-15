Human = {battle = {}}

function Human.battle.update()
    -- for brevity
    local yes = Inputs.yes
    local no = Inputs.no

    -- If a menu is visible, run the appropriate update loop
    if MenuTurnEnd.vis then
        MenuTurnEnd:update()
        return
    elseif MenuBalance.vis then
        MenuBalance:update()
        return
    elseif MenuTarget.vis then
        MenuTarget:update()

        -- accept the balance, close the menu, and end the turn
        if yes:once() then
            -- hide this menu
            MenuTarget.vis = false

            -- attack the enemy unit
            local killed = Cursor.sel:attack(MenuTarget.unit,
                                             MenuTarget.choices[MenuTarget.sel],
                                             Cursor.sel.stat.atk)

            -- delete the enemy unit if it has been destroyed
            if killed then
                Units.die(MenuTarget.idx, Map.current.units)
            end

            -- deactivate all *other* units belonging to the player
            Units.deactivate(Map.current.units, Player.player)
            Cursor.sel:activate()

            -- end the player's turn if the unit is exhausted
            if Cursor.sel:moved() or Cursor.sel.stat.mov == 0 then
                Player:turn_end()
                -- otherwise, show the movement radius
            else
                Radius:update(Cursor.sel, Map.current, Player.player)
            end
        end
        return
    end

    -- update the cursor position
    Cursor:update(Map.current)

    -- determine whether a unit is beneath the cursor
    local unit, idx = Units.at(Cursor.cell.x, Cursor.cell.y, Map.current.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- select friendly unit:
        if unit:friend(Player.player) and not Cursor:selected(unit) and
            unit.active then
            Info:set("select", "", unit)

            if yes:once() then
                Cursor.sel = unit
                Radius:update(unit, Map.current, Player.player)
            end

            -- open friendly balance menu:
        elseif unit:friend(Player.player) and Cursor:selected(unit) and
            not unit:acted() then
            Info:set("balance", "unselect", unit)

            if yes:once() then MenuBalance:open(Cursor.sel, idx) end

            -- open the "turn end" menu if the unit has already
            -- taken an action
        elseif unit:friend(Player.player) and Cursor:selected(unit) and
            unit:acted() then
            Info:set("end turn", "unselect", unit)

            if yes:once() then MenuTurnEnd:open() end

            -- view enemy radii:
        elseif unit:foe(Player.player) and not Cursor:selected() then
            Info:set("view radii", "", unit)

            if yes:once() then
                -- get the enemy player number
                local enemy = 2
                if Player.player == 2 then enemy = 1 end

                -- draw the radii for the enemy player
                Radius:update(unit, Map.current, enemy)
            end

            -- attack enemy:
        elseif unit:foe(Player.player) and Cursor:selected() and
            not Cursor.sel:attacked() and Cursor.sel.active and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            Info:set("attack", "unselect", unit)

            if yes:once() then MenuTarget:open(unit, idx) end
        end

        -- if no unit is beneath the cursor...
    elseif not unit then
        -- move friendly unit:
        if Cursor:selected() and Cursor.sel.active and not Cursor.sel:moved() and
            Cell.open(Cursor.cell.x, Cursor.cell.y, Map.current) and
            Radius:contains('mov', Cursor.cell.x, Cursor.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                Cursor.sel:move(Cursor.cell.x, Cursor.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(Map.current.units, Player.player)
                Cursor.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if Cursor.sel:attacked() or Cursor.sel.stat.atk == 0 or
                    Cursor.sel.stat.rng == 0 then
                    Player:turn_end()
                    -- otherwise, show the attack radius
                else
                    Radius:update(Cursor.sel, Map.current, Player.player)
                end
            end

            -- show the "end turn" menu
        elseif not Cursor:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then MenuTurnEnd:open() end
        end
    end

    -- "Z"
    if no:once() then
        -- hide radii
        if Radius.vis then
            -- unselect the unit if it is ours
            if Cursor:selected() then Cursor.sel = nil end
            Radius:clear()
            -- show the "end turn" menu
        else
            MenuTurnEnd:open()
        end
    end

    -- draw an AStar trail showing the unit movement path
    if Cursor:selected() and
        Radius:contains('mov', Cursor.cell.x, Cursor.cell.y) then
        local src = Cell:new(Cursor.sel.cell.x, Cursor.sel.cell.y,
                             Map.current.cell.w)
        local dst = Cell:new(Cursor.cell.x, Cursor.cell.y, Map.current.cell.w)
        Cursor.path = Cursor.astar:search(src, dst, Map.current)
    else
        Cursor.path = {}
    end
end

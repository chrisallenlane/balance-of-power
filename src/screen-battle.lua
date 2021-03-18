-- update the battle screen
function Screens.battle.update(state, inputs)
    -- only move the camera if units have finished moving
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            state.camera:update(state.cursor, state.map)
        end
    end

    -- determine if the map has been cleared
    -- TODO: handle 2-player games
    local clear, victor = Map.clear(state)
    if clear and victor == 1 then
        Map.advance(state)
        return
    elseif clear and victor == 2 then
        state.screen = Screens.defeat
        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if state.camera.ready and Units.ready then
        if Player:human(state.players) then
            -- TODO: refactor this
            -- If a menu is visible, run the appropriate update loop
            if Menus.TurnEnd.vis then
                Menus.TurnEnd:update(state, inputs)
                return
            elseif Menus.Balance.vis then
                Menus.Balance:update(state, inputs)
                return
            elseif Menus.Target.vis then
                Menus.Target:update(state, inputs)

                -- accept the balance, close the menu, and end the turn
                if inputs.yes:once() then
                    -- hide this menu
                    Menus.Target.vis = false

                    -- attack the enemy unit
                    local killed = state.cursor.sel:attack(Menus.Target.unit,
                                                           Menus.Target.choices[Menus.Target
                                                               .sel],
                                                           state.cursor.sel.stat
                                                               .atk)

                    -- delete the enemy unit if it has been destroyed
                    if killed then
                        Units.die(Menus.Target.idx, state.map.units)
                    end

                    -- deactivate all *other* units belonging to the player
                    Units.deactivate(state.map.units, Player.num)
                    state.cursor.sel:activate()

                    -- end the player's turn if the unit is exhausted
                    if state.cursor.sel:moved() or state.cursor.sel.stat.mov ==
                        0 then
                        Player:turn_end(state)
                        -- otherwise, show the movement radius
                    else
                        Radius:update(state.cursor.sel, state.map, Player.num)
                    end
                end
                return
            end

            -- state = Player.battle.update(state, inputs)
            Player.battle.update(state, inputs)
        else
            CPU.battle.update(state)
        end
    end

    Units.update(state)
end

-- draw the battle screen
function Screens.battle.draw(state)
    cls()

    -- move the camera
    state.camera:draw()

    Map.draw(state)

    -- draw the movement radius
    Radius:draw()

    -- draw the cursor if the player is a human
    if Player:human(state.players) then state.cursor:draw() end

    Units.draw(state)
    Menus.TurnEnd:draw(state)
    Menus.Balance:draw(state)
    Menus.Target:draw(state)
    Info:draw(state)

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars(state) end
end

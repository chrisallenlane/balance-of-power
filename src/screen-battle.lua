-- update the battle screen
function Screens.battle.update(state, inputs)
    -- only move the camera if units have finished moving
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            state.camera:update(state.cursor, Map.current)
        end
    end

    -- determine if the map has been cleared
    -- TODO: handle 2-player games
    local clear, victor = Map:clear()
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
            if MenuTurnEnd.vis then
                MenuTurnEnd:update(state, inputs)
                return
            elseif MenuBalance.vis then
                MenuBalance:update(state, inputs)
                return
            elseif MenuTarget.vis then
                MenuTarget:update(state, inputs)

                -- accept the balance, close the menu, and end the turn
                if inputs.yes:once() then
                    -- hide this menu
                    MenuTarget.vis = false

                    -- attack the enemy unit
                    local killed = state.cursor.sel:attack(MenuTarget.unit,
                                                           MenuTarget.choices[MenuTarget.sel],
                                                           state.cursor.sel.stat
                                                               .atk)

                    -- delete the enemy unit if it has been destroyed
                    if killed then
                        Units.die(MenuTarget.idx, Map.current.units)
                    end

                    -- deactivate all *other* units belonging to the player
                    Units.deactivate(Map.current.units, Player.num)
                    state.cursor.sel:activate()

                    -- end the player's turn if the unit is exhausted
                    if state.cursor.sel:moved() or state.cursor.sel.stat.mov ==
                        0 then
                        Player:turn_end(state)
                        -- otherwise, show the movement radius
                    else
                        Radius:update(state.cursor.sel, Map.current, Player.num)
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

    -- TODO: replace with state var?
    -- Map.current.units = Units:update(Map.current.units)
    Units:update(Map.current.units)
end

-- draw the battle screen
function Screens.battle.draw(state)
    cls()

    -- move the camera
    state.camera:draw()

    Map:draw()

    -- draw the movement radius
    Radius:draw()

    -- draw the cursor if the player is a human
    if Player:human(state.players) then state.cursor:draw() end

    Units.draw(Map.current.units)
    MenuTurnEnd:draw(state)
    MenuBalance:draw(state)
    MenuTarget:draw(state)
    Info:draw(state)

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars(state) end
end

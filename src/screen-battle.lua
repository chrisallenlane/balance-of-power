-- update the battle screen
function Screens.battle.update(inputs)
    -- only move the camera if units have finished moving
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            State.camera:update(Cursor, Map.current)
        end
    end

    -- determine if the map has been cleared
    -- TODO: handle 2-player games
    local clear, victor = Map:clear()
    if clear and victor == 1 then
        Map.advance()
        return
    elseif clear and victor == 2 then
        State.screen = Screens.defeat
        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if State.camera.ready and Units.ready then
        if Player:human(State.players) then
            -- TODO: refactor this
            -- If a menu is visible, run the appropriate update loop
            if MenuTurnEnd.vis then
                MenuTurnEnd:update(inputs)
                return
            elseif MenuBalance.vis then
                MenuBalance:update(inputs)
                return
            elseif MenuTarget.vis then
                MenuTarget:update(inputs)

                -- accept the balance, close the menu, and end the turn
                if inputs.yes:once() then
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
                    Units.deactivate(Map.current.units, Player.num)
                    Cursor.sel:activate()

                    -- end the player's turn if the unit is exhausted
                    if Cursor.sel:moved() or Cursor.sel.stat.mov == 0 then
                        Player:turn_end()
                        -- otherwise, show the movement radius
                    else
                        Radius:update(Cursor.sel, Map.current, Player.num)
                    end
                end
                return
            end

            Player.battle.update(inputs)
        else
            CPU.battle.update()
        end
    end

    -- TODO: replace with state var?
    -- Map.current.units = Units:update(Map.current.units)
    Units:update(Map.current.units)
end

-- draw the battle screen
function Screens.battle.draw()
    cls()

    -- move the camera
    State.camera:draw()

    Map:draw()

    -- draw the movement radius
    Radius:draw()

    -- draw the cursor if the player is a human
    if Player:human(State.players) then Cursor:draw() end

    Units.draw(Map.current.units)
    MenuTurnEnd:draw()
    MenuBalance:draw()
    MenuTarget:draw()
    Info:draw()

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars() end
end

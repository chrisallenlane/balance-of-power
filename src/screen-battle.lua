-- update the battle screen
function Screens.battle.update()
    -- only move the camera if units have finished moving
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            Camera:update(Cursor, Map.current)
        end
    end

    -- determine if the map has been cleared
    -- TODO: handle 2-player games
    local clear, victor = Map:clear()
    if clear and victor == 1 then
        Map.advance()
        return
    elseif clear and victor == 2 then
        Screens.load("defeat")
        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if Camera.ready and Units.ready then
        if Player:human(Players) then
            Human.battle.update()
        else
            CPU.battle.update()
        end
    end

    Units:update()
end

-- draw the battle screen
function Screens.battle.draw()
    cls()

    -- move the camera
    Camera:draw()

    Map:draw()

    -- draw the movement radius
    Radius:draw()

    -- draw the cursor if the player is a human
    if Player:human(Players) then Cursor:draw() end

    Units.draw()
    MenuTurnEnd:draw()
    MenuBalance:draw()
    MenuTarget:draw()
    Info:draw()

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars() end
end

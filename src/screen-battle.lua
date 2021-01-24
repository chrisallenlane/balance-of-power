-- update the battle screen
function Screens.battle.update()
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

    -- If a menu is visible, run the appropriate update loop
    if MenuTurnEnd.vis then
        MenuTurnEnd:update()
        return
    elseif MenuBalance.vis then
        MenuBalance:update()
        return
    elseif MenuTarget.vis then
        MenuTarget:update()
        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if Camera.ready and Units.ready then
        if Turn:human(Players) then
            Cursor:update()
        else
            CPU.update()
        end
    end

    Units:update()

    -- only move the camera if units have finished moving
    if Units.ready then Camera:update() end
end

-- draw the battle screen
function Screens.battle.draw()
    cls()
    Map:draw()

    -- draw the movement radius
    Radius:draw()

    -- draw the cursor if the player is a human
    if Turn:human(Players) then Cursor:draw() end

    Units.draw()
    MenuTurnEnd:draw()
    MenuBalance:draw()
    MenuTarget:draw()

    -- move the camera
    Camera:draw()

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars() end
end

-- update the battle screen
function Screens.battle.update()
    -- determine if the match has been concluded
    local p1, p2 = Units.remain(Map.current.units)

    -- TODO: handle 1-player, 2-player games
    if p1 == 0 then
        -- TODO: display a defeat banner
        Screens.load("defeat")
        return
    end
    if p2 == 0 then
        Map.advance()
        return
    end

    -- If a menu is visible, run the appropriate update loop
    if MenuTurnEnd.vis then
        MenuTurnEnd:update()
        return
    elseif MenuBalance.vis then
        MenuBalance:update(Cursor.sel)
        return
    elseif MenuTarget.vis then
        MenuTarget:update()
        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if Camera.ready and Units.ready then
        if Turn.player == 1 or (Turn.player == 2 and not Players[2].cpu) then
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

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if Turn.player == 1 or (Turn.player == 2 and not Players[2].cpu) then
        Cursor:draw()
    end

    Units.draw()
    MenuTurnEnd:draw()
    MenuBalance:draw()
    MenuTarget:draw()

    -- move the camera
    Camera:draw()

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars() end
end

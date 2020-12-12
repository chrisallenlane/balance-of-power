-- update the battle screen
function Screens.battle.update()
    -- If the "end turn" menu is visible, run its update loop
    if MenuTurnEnd.vis then
        MenuTurnEnd:update()
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

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if Turn.player == 1 or (Turn.player == 2 and not Players[2].cpu) then
        Cursor:draw()
    end

    Units.draw()
    MenuTurnEnd:draw()

    -- move the camera
    Camera:draw()

    -- display debug output
    Debug.vars()
end

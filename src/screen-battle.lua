-- update the battle screen
function Screens.battle.update()
    -- If the "end turn" menu is visible, run its update loop
    if MenuTurnEnd.vis then
        MenuTurnEnd:update()
        return
    end

    Cursor:update()
    Units:update()
    Camera:update()
end

-- draw the battle screen
function Screens.battle.draw()
    cls()
    Game.maps.draw()

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if Cursor.turn == 1 or (Cursor.turn == 2 and not Game.state.cpu) then
        Cursor:draw()
    end

    Units.draw()
    MenuTurnEnd:draw()

    -- move the camera
    Camera:draw()

    -- display debug output
    Debug.vars()
end

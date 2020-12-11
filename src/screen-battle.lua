-- update the battle screen
function Game.screens.battle:update()
    -- If the "end turn" menu is visible, run its update loop
    if self.menu.vis then
        self.menu:update()
        return
    end

    Cursor:update()
    Game.units:update()
    Camera:update()
end

-- draw the battle screen
function Game.screens.battle:draw()
    cls()
    Game.maps.draw()

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if Cursor.turn == 1 or (Cursor.turn == 2 and not Game.state.cpu) then
        Cursor:draw()
    end

    Game.units.draw()
    self.menu:draw()

    -- move the camera
    Camera:draw()

    -- display debug output
    Debug.vars()
end

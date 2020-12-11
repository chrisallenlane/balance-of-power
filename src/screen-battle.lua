-- update the battle screen
function Game.screens.battle:update()
    -- If the "end turn" menu is visible, run its update loop
    if self.menu.vis then
        self.menu:update()
        return
    end

    Game.cursor:update()
    Game.units:update()
    Game.camera:update()
end

-- draw the battle screen
function Game.screens.battle:draw()
    cls()
    Game.maps.draw()

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if Game.cursor.turn == 1 or (Game.cursor.turn == 2 and not Game.state.cpu) then
        Game.cursor:draw()
    end

    Game.units.draw()
    self.menu:draw()

    -- move the camera
    Game.camera:draw()

    -- display debug output
    debug.vars(Game)
end

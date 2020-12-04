-- update the battle screen
function game.screens.battle.update()
    -- If the "end turn" menu is visible, run its update loop
    if game.screens.battle.menu.vis then
        game.screens.battle.menu:update()
        return
    end

    game.cursor:update()
    game.units:update()
    game.camera:update()
end

-- draw the battle screen
function game.screens.battle:draw()
    cls()
    game.maps.draw()

    -- always draw the cursor for player one
    -- only draw the cursor for player 2 when fighting a human enemy
    if game.cursor.turn == 1 or (game.cursor.turn == 2 and not game.state.cpu) then
        game.cursor:draw()
    end

    game.units.draw()
    self.menu:draw()

    -- move the camera
    game.camera:draw()

    -- display debug output
    debug.vars(game)
end

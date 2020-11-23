-- update the battle screen
function game.screens.battle.update()
    -- TODO: map interstitials

    -- If the "end turn" menu is visible, run its update loop
    if game.screens.battle.menu.vis then
        game.screens.battle.menu:update()
    else
        game.cursor:update()
    end

    game.camera:update()
end

-- draw the battle screen
function game.screens.battle:draw()
    cls()
    game.maps.draw()
    game.cursor:draw()
    game.units.draw()
    self.menu:draw()

    -- move the camera
    game.camera:move()

    -- display debug output
    debug.vars(game)
end

-- update the battle screen
function game.screens.battle.update()
    -- TODO: map interstitials
    game.cursor:update()
    game.camera:update()
end

-- draw the battle screen
function game.screens.battle.draw()
    cls()
    game.maps.draw()
    game.cursor:draw()
    game.units.draw()

    -- move the camera
    game.camera:move()

    -- display debug output
    debug.vars(game)
end

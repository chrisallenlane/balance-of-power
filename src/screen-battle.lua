-- update the battle screen
function game.screens.battle.update()

    -- TODO: map interstitials

    if debug.chord(2) then
        if game.state.map < #game.maps then
            game.state.map = game.state.map + 1
            game.maps.load(game.state.map)
        else
            game.screens.load("victory")
        end
    elseif debug.chord(3) then
        game.screens.load("defeat")
    end

    game.cursor:update()
    -- XXX: this causes MEM to thrash
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

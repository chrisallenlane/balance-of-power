-- update the title screen
function game.screens.title.update()
    if debug.chord(2) then
        game.maps.load(1)
        game.screens.load("battle")
    end
end

-- draw the title screen
function game.screens.title.draw()
    rectfill(0, 0, 127, 127, 12)
    print("balance of power", 39, 56, 1)
end

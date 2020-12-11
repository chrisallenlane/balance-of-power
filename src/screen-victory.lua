-- update the victory screen
function Game.screens.victory.update()
end

-- draw the victory screen
function Game.screens.victory.draw()
    rectfill(0, 0, 127, 127, 12)
    print("you win", 39, 56, 1)
    camera(0, 0)
end

game.units = {}

-- draw the units
function game.units.draw()
    for _, unit in ipairs(game.map.units.p1) do
        spr(unit[1], unit[2], unit[3])
    end
    for _, unit in ipairs(game.map.units.p2) do
        spr(unit[1], unit[2], unit[3])
    end
end

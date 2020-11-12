game.units = {}

-- draw the units
function game.units.draw()
    for x, ys in pairs(game.map.units.p1) do
        for y, unit in pairs(ys) do spr(unit.spr, x * 8, y * 8) end
    end
    for x, ys in pairs(game.map.units.p2) do
        for y, unit in pairs(ys) do spr(unit.spr, x * 8, y * 8) end
    end
end

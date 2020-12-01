game.units = {}

-- draw the units
function game.units.draw()
    for _, ys in pairs(game.map.units) do
        for _, unit in pairs(ys) do spr(unit.spr, unit.px.x, unit.px.y) end
    end
end

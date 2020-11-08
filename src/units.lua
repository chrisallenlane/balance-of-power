game.units = {}

-- draw the units
function game.units.draw()
    for _, unit in ipairs(game.map.units.p1) do
        spr(unit.spr, unit.cell.x, unit.cell.y)
    end
    for _, unit in ipairs(game.map.units.p2) do
        spr(unit.spr, unit.cell.x, unit.cell.y)
    end
end

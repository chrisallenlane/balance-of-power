game.units = {}

-- draw the units
function game.units.draw()
    for _, unit in ipairs(game.map.units.p1) do
        spr(unit.spr, unit.cell.x*8, unit.cell.y*8)
    end
    for _, unit in ipairs(game.map.units.p2) do
        spr(unit.spr, unit.cell.x*8, unit.cell.y*8)
    end
end

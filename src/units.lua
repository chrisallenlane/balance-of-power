game.units = {}

-- draw the units
function game.units.draw()
    for _, unit in pairs(game.map.units) do
        spr(unit.spr, unit.px.x, unit.px.y)
    end
end

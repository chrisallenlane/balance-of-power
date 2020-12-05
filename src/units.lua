game.units = {}

-- update unit coordinates
function game.units.update()
    for _, unit in pairs(game.map.units) do
        -- x
        if unit.px.x < unit.cell.x * 8 then
            unit.px.x = unit.px.x + 4
        elseif unit.px.x > unit.cell.x * 8 then
            unit.px.x = unit.px.x - 4
        end

        -- y
        if unit.px.y < unit.cell.y * 8 then
            unit.px.y = unit.px.y + 4
        elseif unit.px.y > unit.cell.y * 8 then
            unit.px.y = unit.px.y - 4
        end
    end
end

-- draw the units
function game.units.draw()
    for _, unit in pairs(game.map.units) do
        spr(unit.spr, unit.px.x, unit.px.y)
    end
end

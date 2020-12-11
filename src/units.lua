Units = {}

-- update unit coordinates
function Units.update()
    -- unlock the cursor
    Game.lock.unit = false

    -- if a unit is in-motion, lock the cursor
    for _, unit in pairs(Game.map.units) do
        -- x
        if unit.px.x < unit.cell.x * 8 then
            unit.px.x = unit.px.x + 4
            Game.lock.unit = true
        elseif unit.px.x > unit.cell.x * 8 then
            unit.px.x = unit.px.x - 4
            Game.lock.unit = true
        end

        -- y
        if unit.px.y < unit.cell.y * 8 then
            unit.px.y = unit.px.y + 4
            Game.lock.unit = true
        elseif unit.px.y > unit.cell.y * 8 then
            unit.px.y = unit.px.y - 4
            Game.lock.unit = true
        end
    end
end

-- draw the units
function Units.draw()
    for _, unit in pairs(Game.map.units) do
        spr(unit.spr, unit.px.x, unit.px.y)
    end
end

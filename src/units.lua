Units = {ready = true, delay = 0}

-- update unit coordinates
function Units.update()
    -- assume that units are ready
    Units.ready = true

    -- if a unit is in-motion, lock the cursor
    for _, unit in pairs(Map.current.units) do
        -- x
        if unit.px.x < unit.cell.x * 8 then
            unit.px.x = unit.px.x + 4
            Units.ready = false
        elseif unit.px.x > unit.cell.x * 8 then
            unit.px.x = unit.px.x - 4
            Units.ready = false
        end

        -- y
        if unit.px.y < unit.cell.y * 8 then
            unit.px.y = unit.px.y + 4
            Units.ready = false
        elseif unit.px.y > unit.cell.y * 8 then
            unit.px.y = unit.px.y - 4
            Units.ready = false
        end
    end
end

-- draw the units
function Units.draw()
    for _, unit in pairs(Map.current.units) do
        -- XXX: assume that unit.spr+1 is the inactive sprite
        local sprite = unit.spr
        if not unit.active then sprite = sprite + 1 end
        spr(sprite, unit.px.x, unit.px.y)
    end
end

-- Remain returns the number of units remaining for each player
function Units.remain(units)
    -- track the number of units remaining for each player
    local p1, p2 = 0, 0

    -- iterate over all units on the map
    for _, unit in pairs(units) do
        if unit.player == 1 then p1 = p1 + 1 end
        if unit.player == 2 then p2 = p2 + 1 end
    end

    return p1, p2
end

-- deactivate all units
function Units.deactivate(units, player)
    for _, unit in pairs(units) do
        if unit.player == player then unit:deactivate() end
    end
end

-- refresh all units
function Units.refresh(units)
    for _, unit in pairs(units) do unit:refresh() end
end

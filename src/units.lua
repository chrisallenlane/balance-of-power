Units = {ready = true, delay = 0}

-- XXX TODO: this is very inefficient
-- update unit coordinates
function Units.update(state)
    -- assume that units are ready
    Units.ready = true

    -- TODO: use local state
    -- if a unit is in-motion, lock the cursor
    for _, unit in pairs(state.stage.units) do
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

-- At returns the unit at the specified coordinates, or false if none is there
function Units.at(x, y, units)
    -- XXX: this runs in linear time
    for idx, unit in pairs(units) do
        if unit.cell.x == x and unit.cell.y == y then return unit, idx end
    end

    return nil, nil
end

-- Returns the first unit on `player`'s team team
function Units.first(player, units)
    -- XXX: this runs in linear time
    for _, unit in pairs(units) do
        if unit.player == player then return unit end
    end

    -- NB: we realistically should never end up here
    -- TODO: throw exception if we somehow do
    return false
end

-- draw the units
function Units.draw(state)
    for _, unit in pairs(state.stage.units) do
        -- NB: assume that unit.spr+1 is the inactive sprite
        local sprite = unit.spr
        if not unit.active then sprite = sprite + 1 end
        spr(sprite, unit.px.x, unit.px.y)
    end
end

-- Remain returns the number of units remaining for each player
function Units.remain(units)
    -- track the number of units remaining for each player
    local p1, p2 = 0, 0

    -- iterate over all units on the stage
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

-- Die kills a unit
function Units.die(idx, units)
    deli(units, idx)
end

Cell = {
    -- enum of cell traversal costs
    mvmt = {
        [1] = 1, -- grass
        [49] = 1, -- sand
        [33] = 0.5, -- road
        [17] = 1 / 0, -- shallow water
        [18] = 1 / 0, -- deep water
    },
}

-- return true if a unit may be placed on the tile
function Cell.open(x, y, map)
    -- return false if the specified coordinates are out-of-bounds
    if x < 0 or x >= map.cell.w or y < 0 or y >= map.cell.h then return false end

    -- return false if the map tile at the specified coordinates is flagged as
    -- impassible
    if fget(mget(map.cell.x + x, map.cell.y + y), 0) then return false end

    -- return false if a unit is at the specified coordinates
    -- TODO: pass as param
    if Unit.at(x, y, Map.current.units) then return false end
    return true
end

-- return true if a unit may pass through the tile
function Cell.pass(x, y, map, turn)
    -- return false if the specified coordinates are out-of-bounds
    if x < 0 or x >= map.cell.w or y < 0 or y >= map.cell.h then return false end

    -- return false if the map tile at the specified coordinates is flagged as
    -- impassible
    if fget(mget(map.cell.x + x, map.cell.y + y), 0) then return false end

    -- TODO: pass as param
    -- check for a unit at the specified coordinates
    local unit = Unit.at(x, y, Map.current.units)

    -- if no unit is found, return true
    if not unit then return true end

    -- if a unit is found, but is on our team, return true
    if unit and unit.player == turn then return true end

    -- if a unit is found but is on the enemy team, return false
    return false
end

-- return the cell traversal cost at `x`, `y`
-- XXX: should this default to `1`, or `throw`?
function Cell:cost(x, y)
    return self.mvmt[mget(x, y)] or 1
end

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

-- return true if the map tile is passable
function Cell.passable(x, y, map)
    -- return false if the map tile at the specified coordinates is flagged as
    -- impassible
    if fget(mget(map.cell.x + x, map.cell.y + y), 0) then return false end

    -- return false if a unit is at the specified coordinates
    -- TODO: pass as param
    if Unit.at(x, y, Map.current.units) then return false end
    return true
end

-- return the cell traversal cost at `x`, `y`
-- XXX: should this default to `1`, or `throw`?
function Cell:cost(x, y)
    return self.mvmt[mget(x, y)] or 1
end

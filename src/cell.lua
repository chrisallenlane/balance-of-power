Cell = {id = nil, x = nil, y = nil, w = nil, parent = nil}

-- Cell constructor
function Cell:new(x, y, w)
    local c = {x = x, y = y, id = (y * w) + x}
    setmetatable(c, self)
    self.__index = self
    return c
end

-- return true if a unit may be placed on the tile
function Cell.open(x, y, stage)
    -- return false if the specified coordinates are out-of-bounds
    if x < 0 or x >= stage.cell.w or y < 0 or y >= stage.cell.h then
        return false
    end

    -- return false if the stage tile at the specified coordinates is flagged as
    -- impassible
    if fget(mget(stage.cell.x + x, stage.cell.y + y), 0) then return false end

    -- return false if a unit is at the specified coordinates
    -- TODO: pass as param
    if Units.at(x, y, stage.units) then return false end
    return true
end

-- return true if a unit may pass through the tile
function Cell.pass(x, y, stage, turn)
    -- if the cell is not open, it's also not passable
    if not Cell.open(x, y, stage) then return false end

    -- check for a unit at the specified coordinates
    -- TODO: de-duplicate with `self.open`, possibly via a state var
    local unit = Units.at(x, y, stage.units)

    -- if no unit is found, return true
    if not unit then return true end

    -- if a unit is found, but is on our team, return true
    if unit and unit.player == turn then return true end

    -- if a unit is found but is on the enemy team, return false
    return false
end

-- return the cell traversal cost at `x`, `y`
function Cell.cost(x, y, stage)
    -- stage cell traversal costs
    local costs = {
        [1] = 1, -- grass
        [49] = 1, -- sand
        [33] = 0.5, -- road
        [17] = 1 / 0, -- shallow water
        [18] = 1 / 0, -- deep water
    }

    return costs[mget(stage.cell.x + x, stage.cell.y + y)]
end

-- return the set of cells adjacent to the specified cell
function Cell.neighbors(x, y, stage)
    local neighbors = {}

    -- add cells, while being mindful to stay in bounds
    if x + 1 < stage.cell.w then
        add(neighbors, Cell:new(x + 1, y, stage.cell.w))
    end
    if x - 1 >= 0 then add(neighbors, Cell:new(x - 1, y, stage.cell.w)) end
    if y + 1 < stage.cell.h then
        add(neighbors, Cell:new(x, y + 1, stage.cell.w))
    end
    if y - 1 >= 0 then add(neighbors, Cell:new(x, y - 1, stage.cell.w)) end

    return neighbors
end

-- returns `true` if cells `a` and `b` are equal
function Cell:is(c)
    return self.id == c.id
end

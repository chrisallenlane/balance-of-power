Cell = {id = nil, x = nil, y = nil, w = nil, parent = nil}

-- Cell constructor
function Cell:new(x, y, w)
    local c = {x = x, y = y, id = (y * w) + x}
    setmetatable(c, self)
    self.__index = self
    return c
end

-- returns true if the specified cell is out-of-bounds
function Cell.oob(x, y, stage)
    -- return false if the specified coordinates are out-of-bounds
    if x < 0 or x >= stage.cell.w or y < 0 or y >= stage.cell.h then
        return true
    end

    return false
end

-- return true if a unit may be placed on the tile
function Cell.open(x, y, stage)
    -- if the cell is out-of-bounds, it's not open
    if Cell.oob(x, y, stage) then return false end

    -- return false if a unit is at the specified coordinates
    if Units.at(x, y, stage.units) then return false end
    return true
end

-- return true if a unit may pass through the tile
function Cell.pass(x, y, stage, turn)
    -- if the cell is out-of-bounds, it's not passable
    if Cell.oob(x, y, stage) then return false end

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
    -- assume a traversal cost of 1
    local cost = 1

    -- create an "infinity" value
    local inf = 1 / 0

    -- determine if the tile has a "special" traversal cost
    -- stage cell traversal costs
    local costs = {
        -- road/bridge
        [71] = 0.5,
        [72] = 0.5,
        [73] = 0.5,
        [74] = 0.5,
        [75] = 0.5,
        [87] = 0.5,
        [88] = 0.5,
        [89] = 0.5,
        [90] = 0.5,
        [91] = 0.5,
        [103] = 0.5,
        [104] = 0.5,
        [105] = 0.5,
        [119] = 0.5,
        [120] = 0.5,
        [121] = 0.5,

        -- shore
        [101] = inf,
        [102] = inf,
        [117] = inf,
        [118] = inf,

        -- water
        [96] = inf,
        [112] = inf,
    }
    local special = costs[mget(stage.cell.x + x, stage.cell.y + y)]

    -- if it does, return the special
    if special then cost = special end
    return cost
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

Cell = {id = nil, x = nil, y = nil, w = nil, costs = {}}

-- Build a map of [tile number] => [traversal cost]
-- NB: we're doing this rather than hard-coding a map simply to reduce the
-- number of "tokens" required.
function Cell.init()
    -- create an infinity value
    local inf = 1 / 0

    -- enumerate tile costs (in a token-efficient way)
    local costs = {
        -- road/city
        {
            tiles = split(
                "71,72,73,74,75,87,88,89,90,91,103,104,105,112,119,120,121"),
            cost = 0.5,
        },
        -- forest
        {
            tiles = split(
                "76,77,78,79,92,93,94,95,106,107,108,109,110,111,122,123,124,125,126,127"),
            cost = 1.5,
        },
        -- mountain
        {
            tiles = split(
                "32,33,34,35,36,37,38,39,40,41,48,49,50,51,52,53,54,55,56,57"),
            cost = 2,
        },
        -- impassible (shore/water)
        {tiles = split("96,101,102,117,118"), cost = inf},
    }

    -- build a map of [tile number] => [traversal cost]
    local map = {}
    for _, set in pairs(costs) do
        for _, tile in pairs(set.tiles) do map[tile] = set.cost end
    end

    return map
end

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

    -- determine if the tile has a "special" traversal cost
    -- stage cell traversal costs
    local special = Cell.costs[mget(stage.cell.x + x, stage.cell.y + y)]

    -- if it does, return the special
    if special then cost = special end
    return cost
end

-- return the set of cells adjacent to the specified cell
function Cell.neighbors(x, y, stage)
    local cell, nbrs = stage.cell, {}

    -- add cells, while being mindful to stay in bounds
    if x + 1 < cell.w then add(nbrs, Cell:new(x + 1, y, cell.w)) end
    if x - 1 >= 0 then add(nbrs, Cell:new(x - 1, y, cell.w)) end
    if y + 1 < cell.h then add(nbrs, Cell:new(x, y + 1, cell.w)) end
    if y - 1 >= 0 then add(nbrs, Cell:new(x, y - 1, cell.w)) end

    return nbrs
end

-- returns `true` if cells `a` and `b` are equal
function Cell:is(c)
    return self.id == c.id
end

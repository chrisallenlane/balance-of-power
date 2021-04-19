Cell = {id = nil, x = nil, y = nil, w = nil, costs = {}}

-- Build a map of [tile number] => [traversal cost], [terrain defense]
-- NB: cell data is thusly serialized to reduce the number of required tokens
function Cell.init()
    -- column 1: map tile IDs
    -- column 2: traversal cost
    -- column 3: defense modifier
    local costs = {
        -- city
        "112|0.5|1",

        -- road
        "71,72,73,74,75,87,88,89,90,91,103,104,105,119,120,121|0.5|-1",

        -- forest
        "76,77,78,79,92,93,94,95,106,107,108,109,110,111,122,123,124,125,126,127|1.5|1.",

        -- mountain
        "16,17,18,19,32,33,34,35,36,37,38,39,48,49,50,51,52,53,54,55|2|2",

        -- impassible (shore/water)
        "96,101,102,117,118|1000|0",
    }

    -- build the map
    local map = {}

    -- iterate over each row in the costs table
    for _, row in ipairs(costs) do

        -- split each row into columns
        local cols = split(row, "|")

        -- assemble the cost map in memory
        for _, tile in ipairs(split(cols[1])) do
            map[tile] = {cost = cols[2], def = cols[3]}
        end
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
    -- @todo: de-duplicate with `self.open`, possibly via a state var
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
    -- look up a traversal cost for the tile
    local tile = Cell.costs[mget(stage.cell.x + x, stage.cell.y + y)]

    -- if a cost is specified, return it
    if tile then return tile.cost end

    -- otherwise, return the default
    return 1
end

-- return the cell traversal cost at `x`, `y`
-- @todo: this should be de-duplicated with the above
function Cell.def(x, y, stage)
    -- look up a traversal cost for the tile
    local tile = Cell.costs[mget(stage.cell.x + x, stage.cell.y + y)]

    -- if a cost is specified, return it
    if tile then return tile.def end

    -- otherwise, return the default
    return 0
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

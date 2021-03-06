Cell = {id = nil, x = nil, y = nil, w = nil, data = {}}

-- Build a map of [tile number] => [traversal cost], [terrain defense], [repair value]
-- NB: cell data is thusly serialized to reduce the number of required tokens
function Cell.init()
  -- column 1: map tile IDs
  -- column 2: traversal cost
  -- column 3: defense modifier
  -- column 4: cell repair value
  local data = {
    -- XXX TODO: remove this when enemies may no longer move offscreen
    '0|1|0|0',

    -- land
    '64,65,66,67,68,69,70,81,82,83,84,85,86|1|0|0',

    -- shore
    '97,98,99,100,101,102,113,114,115,116,117,118|1|0|0',

    -- city
    '5,6,7,20,21,22,23,24|0.5|1|1',

    -- road
    '71,72,73,74,75,87,88,89,90,91,112|0.5|-1|0',

    -- bridge
    '103,104,105,119,120,121|0.5|-2|0',

    -- forest
    '76,77,78,79,80,92,93,94,95,106,107,108,109,110,111,122,123,124,125,126,127|1.5|1|0',

    -- mountain
    '16,17,18,19,32,33,34,35,36,37,38,39,48,49,50,51,52,53,54,55|2|2|0',

    -- shore/water (impassible)
    '96,101,102,117,118|1000|0|0',
  }

  -- build the map
  local map = {}

  -- iterate over each row in the data table
  for _, row in ipairs(data) do

    -- split each row into columns
    local cols = split(row, '|')

    -- assemble the map in memory
    for _, tile in ipairs(split(cols[1])) do
      map[tile] = {cost = cols[2], def = cols[3], repair = cols[4]}
    end
  end

  return map
end

-- Cell constructor
function Cell:new(x, y, state)
  local c = {x = x, y = y, id = (y * state.stage.cellw) + x}
  setmetatable(c, self)
  self.__index = self
  return c
end

-- returns true if the specified cell is out-of-bounds
function Cell.oob(x, y, state)
  -- return false if the specified coordinates are out-of-bounds
  if x < 0 or x >= state.stage.cellw or y < 0 or y >= state.stage.cellh then
    return true
  end

  return false
end

-- return true if a unit may be placed on the tile
function Cell.open(x, y, state)
  -- if the cell is out-of-bounds, it's not open
  if Cell.oob(x, y, state) then return false end

  -- return false if a unit is at the specified coordinates
  if Units.at(x, y, state.stage.units) then return false end
  return true
end

-- return true if a unit may pass through the tile
function Cell.pass(x, y, state, turn)
  -- if the cell is out-of-bounds, it's not passable
  if Cell.oob(x, y, state) then return false end

  -- check for a unit at the specified coordinates
  -- TODO: de-duplicate with `self.open`, possibly via a state var
  local unit = Units.at(x, y, state.stage.units)

  -- if no unit is found, return true
  if not unit then return true end

  -- if a unit is found, but is on our team, return true
  if unit and unit.player == turn then return true end

  -- if a unit is found but is on the enemy team, return false
  return false
end

-- fetch information about a cell
function Cell.datum(x, y, key, state)
  return Cell.data[mget(state.stage.cellx + x, state.stage.celly + y)][key]
end

-- return the set of cells adjacent to the specified cell
function Cell.neighbors(x, y, state)
  local nbrs = {}

  -- add cells, while being mindful to stay in bounds
  if x + 1 < state.stage.cellw then add(nbrs, Cell:new(x + 1, y, state)) end
  if x - 1 >= 0 then add(nbrs, Cell:new(x - 1, y, state)) end
  -- NB: the `+ 2` is not a typo. The bottommost row in each map is "empty",
  -- because the Info bar is written on top of it. This adjustment prevents
  -- units from moving behind the Info bar.
  if y + 2 < state.stage.cellh then add(nbrs, Cell:new(x, y + 1, state)) end
  if y - 1 >= 0 then add(nbrs, Cell:new(x, y - 1, state)) end

  return nbrs
end

-- returns `true` if cells `a` and `b` are equal
function Cell:is(c)
  return self.id == c.id
end

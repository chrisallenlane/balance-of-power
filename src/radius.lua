Radius = {}

function Radius:new()
  local r = {
    center = {x = nil, y = nil},
    cells = {atk = {}, dng = {}, mov = {}},
    cache = {atk = {}, dng = {}, mov = {}},
    vis = false,
  }

  setmetatable(r, self)
  self.__index = self

  return r
end

-- draw a radius at the specified coordinates
function Radius:update(unit, state, turn)
  -- clear the prior radius
  self:clear()

  -- annotate the center of the radii
  self.center.x, self.center.y = unit.cellx, unit.celly

  -- NB: we're computing the movement and attack radii separately. That's
  -- not computationally optimial, but much simpler to understand.
  if not unit.moved then
    self:move(self.center.x, self.center.y, unit.stat.mov, state, turn)
  end
  -- if the unit has range but no attack, don't render an attack radius
  if not unit.attacked and unit.stat.atk > 0 then
    -- don't "pay for" the cell where the unit is placed
    self:append('mov', unit.cellx, unit.celly)
    self:dng(self.center.x, self.center.y, unit.stat.rng, state, turn)
    self:atk(self.center.x, self.center.y, unit.stat.rng, state, turn)
  end

  -- annotate that the radius is visible
  self.vis = true
end

-- Compute a movement radius centered on `x`, `y`
function Radius:move(x, y, mvmt, state, turn)
  -- short circuit if the unit has no `mov` points
  if mvmt == 0 then return end

  -- if we've visited this cell before (with `mvmt` movement points
  -- remaining), exit early
  if self:cached('mov', x, y, mvmt) then return end

  -- iteratively search this cell's neighbors
  for _, cell in pairs(Cell.neighbors(x, y, state)) do
    -- determine the cost to traverse the tile
    local cost = Cell.datum(cell.x, cell.y, 'cost', state)
    if mvmt >= cost and Cell.pass(cell.x, cell.y, state, turn) then
      if Cell.open(cell.x, cell.y, state) then
        self:append('mov', cell.x, cell.y)
      end
      self:move(cell.x, cell.y, mvmt - cost, state, turn)
    end
  end
end

-- Compute an attack radius centered on `x`, `y`
function Radius:atk(x, y, rng, state, turn)
  -- exit early if we've visited this cell before (with `rng` range points remaining)
  if self:cached('atk', x, y, rng) then return end

  -- pay the range cost
  rng = rng - 1

  -- exit early if we have exhausted our attack radius
  if rng < 0 then return end

  -- iteratively search this cell's neighbors
  for _, cell in pairs(Cell.neighbors(x, y, state)) do
    -- append the cell to the attack radius if and only if:
    -- 1. the cell is unoccupied
    -- 2. the cell is occupied by an enemy unit
    local unit = Units.at(cell.x, cell.y, state.stage.units)
    if not unit or unit and unit.player ~= turn then
      self:append('atk', cell.x, cell.y)
    end

    self:atk(cell.x, cell.y, rng, state, turn)
  end
end

-- Compute a danger radius centered on `x`, `y`
function Radius:dng(x, y, rng, state, turn)
  -- exit early if we've visited this cell before (with `rng` range points remaining)
  if self:cached('dng', x, y, rng) then return end

  -- cells within the movement radius are implicitly within the attack
  -- radius, so we get those "for free".
  if not self:contains('mov', x, y) then rng = rng - 1 end

  -- exit early if we have exhausted our attack radius
  if rng == 0 then return end

  -- iteratively search this cell's neighbors
  for _, cell in pairs(Cell.neighbors(x, y, state)) do
    -- append the cell to the danger radius if and only if:
    -- 1. the cell is unoccupied
    -- 2. the cell is occupied by an enemy unit
    local unit = Units.at(cell.x, cell.y, state.stage.units)
    if not unit or unit and unit.player ~= turn then
      self:append('dng', cell.x, cell.y)
    end

    self:dng(cell.x, cell.y, rng, state, turn)
  end
end

-- return true if we have already visited a cell with `m` movement remaining
function Radius:cached(key, x, y, m)
  -- return true if we've been here before
  if self.cache[key][x] and self.cache[key][x][y] and self.cache[key][x][y][m] then
    return true
  end

  -- otherwise, note that we've *now* been here, and return false
  if not self.cache[key][x] then self.cache[key][x] = {} end
  if not self.cache[key][x][y] then self.cache[key][x][y] = {} end
  if not self.cache[key][x][y][m] then self.cache[key][x][y][m] = true end
  return false
end

-- append a cell to the radius
function Radius:append(key, x, y)
  if not self.cells[key][x] then self.cells[key][x] = {} end
  self.cells[key][x][y] = true
end

-- remove a cell from the radius
function Radius:remove(key, x, y)
  if self.cells[key] and self.cells[key][x] and self.cells[key][x][y] then
    self.cells[key][x][y] = nil
  end
end

-- return true if x,y is among the cells within the radius
function Radius:contains(key, x, y)
  return self.cells[key][x] and self.cells[key][x][y]
end

-- reset the radius coordinates
function Radius:clear()
  self.cache = {atk = {}, dng = {}, mov = {}}
  self.cells = {atk = {}, dng = {}, mov = {}}
  self.vis = false
end

-- return a random cell contained within the radius
function Radius:rand(key, state)
  -- track x and y keys
  local xs, ys = {}, {}

  -- get available x keys; grab a random x
  for x, _ in pairs(self.cells[key]) do add(xs, x) end
  local x = rnd(xs)

  -- get available y keys; grab a random y
  for y, _ in pairs(self.cells[key][x]) do add(ys, y) end
  local y = rnd(ys)

  -- NB: if a unit has an empty movement radius, x and y will both be empty.
  -- We only test for `x` here to save tokens, because each cell necessarily
  -- has an x, y coordinate. If `x` is empty, we can be confident that the
  -- movement radius is empty, and thus return false.
  return x and Cell:new(x, y, state) or false
end

-- find cells that are common to both `self` and `rad` iterate over
-- numerically-indexed table
function Radius:intersect(keySelf, keyOther, rad)
  -- initialize a new radius to store the intersection of cells
  local intersection = Radius:new()

  -- iterate over every cell in the (specified) radius
  for x, cell in pairs(self.cells[keySelf]) do
    for y, _ in pairs(cell) do
      if rad:contains(keyOther, x, y) then
        intersection:append(keySelf, x, y)
      end
    end
  end

  -- return the intersecting cells
  return intersection
end

-- find cells from which the attacker may attack the target
function Radius.vantage(attacker, target, state)
  -- compute a new radius centered on the target's position
  local rad = Radius:new()
  rad:atk(target.cellx, target.celly, attacker.stat.rng, state, state.player.num)

  -- identify the subset of cells in the intersection of the selected unit and
  -- target radii
  return rad:intersect('atk', 'mov', attacker.radius)
end

-- draw the radius to the stage
function Radius:draw(friend)
  if not self.vis then return end

  -- use "interlocking" sprites for teams
  local sprite = friend and 2 or 3

  -- draw the danger radius
  pal(10, 14)
  for x, cell in pairs(self.cells.dng) do
    for y, _ in pairs(cell) do spr(sprite, x * 8, y * 8) end
  end

  -- draw the movement radius
  pal(10, 1)
  for x, cell in pairs(self.cells.mov) do
    for y, _ in pairs(cell) do spr(sprite, x * 8, y * 8) end
  end
  pal()
end

Radius = {cells = {atk = {}, move = {}}, cache = {atk = {}, move = {}}}

-- draw a radius at the specified coordinates
function Radius:update(unit, map, turn)
    -- clear the prior radius
    self:clear()
    -- NB: we're computing the movement and attack radii separately. That's
    -- not computationally optimial, but much simpler to understand.
    self:move(unit.cell.x, unit.cell.y, unit.stat.spd, map, turn)
    self:atk(unit.cell.x, unit.cell.y, unit.stat.rng, map)
    self.cache = nil
end

-- Compute a movement radius centered on `x`, `y`
function Radius:move(x, y, mvmt, map, turn)
    -- if we've visited this cell before (with `mvmt` movement points
    -- remaining), exit early
    if self:cached('move', x, y, mvmt) then return end

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Radius.neighbors(x, y)) do
        -- determine the cost to traverse the tile
        local cost = Cell:cost(cell.x, cell.y)
        if mvmt >= cost and Cell.pass(cell.x, cell.y, map, turn) then
            self:append('move', cell.x, cell.y)
            Radius:move(cell.x, cell.y, mvmt - cost, map, turn)
        end
    end
end

-- Compute an attack radius centered on `x`, `y`
function Radius:atk(x, y, rng, map)
    -- exit early if we've visited this cell before (with `rng` range points remaining)
    if self:cached('atk', x, y, rng) then return end

    -- cells within the movement radius are implicitly within the attack
    -- radius, so we get those "for free".
    if not self:contains('move', x, y) then rng = rng - 1 end

    -- exit early if we have exhausted our attack radius
    if rng == 0 then return end

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Radius.neighbors(x, y)) do
        self:append('atk', cell.x, cell.y)
        Radius:atk(cell.x, cell.y, rng, map)
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

-- append the specified coordinate pair to set of radius cells
function Radius:append(key, x, y)
    if not self.cells[key][x] then self.cells[key][x] = {} end
    self.cells[key][x][y] = true
end

-- return the set of cells adjacent to the specified cell
function Radius.neighbors(x, y)
    local neighbors = {}

    -- add cells, while being mindful to stay in bounds
    if x + 1 <= Map.current.cell.w then add(neighbors, {x = x + 1, y = y}) end
    if x - 1 >= 0 then add(neighbors, {x = x - 1, y = y}) end
    if y + 1 <= Map.current.cell.h then add(neighbors, {x = x, y = y + 1}) end
    if y - 1 >= 0 then add(neighbors, {x = x, y = y - 1}) end

    return neighbors
end

-- return true if x,y is among the cells within the radius
function Radius:contains(key, x, y)
    return self.cells[key][x] and self.cells[key][x][y]
end

-- reset the radius coordinates
function Radius:clear()
    self.cache = {atk = {}, move = {}}
    self.cells = {atk = {}, move = {}}
end

-- draw the radius to the map
function Radius:draw()
    -- draw the attack cells before the movement cells, because the latter are
    -- a subset of the former
    for x, cell in pairs(self.cells.atk) do
        for y, _ in pairs(cell) do spr(50, x * 8, y * 8) end
    end
    for x, cell in pairs(self.cells.move) do
        for y, _ in pairs(cell) do spr(48, x * 8, y * 8) end
    end
end

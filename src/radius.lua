Radius = {cells = {atk = {}, move = {}}, cache = {atk = {}, move = {}}}

-- draw a radius at the specified coordinates
function Radius:update(unit, turn)
    -- clear the prior radius
    self:clear()
    self:search(unit.cell.x, unit.cell.y, unit.stat.spd, unit.stat.rng, turn)
    self.cache = nil
end

-- search the tiles which compose the radius centered on `x`, `y`
function Radius:search(x, y, mvmt, rng, turn)
    -- if we've visited this cell before (with the `mvmt` movement points
    -- remaining), exit early
    if self:cached('move', x, y, mvmt) then return end

    -- look up the cell traversal cost
    local cost = Cell:cost(x, y)

    -- if we can't pay the traversal cost, exit early
    if cost > mvmt then return end

    -- otherwise, deduct the traversal cost
    mvmt = mvmt - cost

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Radius.neighbors(x, y)) do
        -- TODO: refactor map width into function call param
        if Cell.pass(cell.x, cell.y, Map.current, turn) then
            self:append('move', cell.x, cell.y)
            -- enforce the movement cost constraint by limiting recursive depth
            if mvmt > 0 then
                Radius:search(cell.x, cell.y, mvmt, rng, turn)
            end
        end
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
    for x, cell in pairs(self.cells.move) do
        for y, _ in pairs(cell) do spr(48, x * 8, y * 8) end
    end
end

Radius = {cells = {}, cache = {}}

-- return true if we have already visited a cell with `m` movement remaining
function Radius:cached(x, y, m)
    -- return true if we've been here before
    if self.cache[x] and self.cache[x][y] and self.cache[x][y][m] then
        return true
    end

    -- otherwise, note that we've *now* been here, and return false
    if not self.cache[x] then self.cache[x] = {} end
    if not self.cache[x][y] then self.cache[x][y] = {} end
    if not self.cache[x][y][m] then self.cache[x][y][m] = true end
    return false
end

-- draw a radius at the specified coordinates
function Radius:update(x, y, mvmt)
    -- clear the prior radius
    self:clear()
    self:search(x, y, mvmt)
end

-- TODO: account for "reachability"
function Radius:search(x, y, mvmt)
    if self:cached(x, y, mvmt) then return end

    printh("visiting: " .. x .. ", " .. y .. " (" .. mvmt .. ")")

    for _, cell in pairs(Radius.neighbors(x, y)) do
        -- TODO: refactor map width into function call param
        if Cell.passable(cell.x, cell.y, Map.current) then
            self:append(cell.x, cell.y)
            -- limit recursive depth
            if mvmt > 1 then
                -- TODO: decrement by tile movement cost
                Radius:search(cell.x, cell.y, mvmt - 1)
            end
        end
    end
end

-- append the specified coordinate pair to set of radius cells
function Radius:append(x, y)
    if not self.cells[x] then self.cells[x] = {} end
    self.cells[x][y] = true
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
function Radius:contains(x, y)
    return self.cells[x] and self.cells[x][y]
end

-- reset the radius coordinates
function Radius:clear()
    self.cache = {}
    self.cells = {}
end

-- draw the radius to the map
function Radius:draw()
    for x, cell in pairs(self.cells) do
        for y, _ in pairs(cell) do spr(48, x * 8, y * 8) end
    end
end

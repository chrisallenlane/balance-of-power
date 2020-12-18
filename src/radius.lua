Radius = {cells = {}}

-- draw a radius at the specified coordinates
function Radius:update(x, y)
    -- clear the prior radius
    self:clear()

    for _, cell in pairs(self.near(x, y)) do self:append(cell.x, cell.y) end
end

-- append the specified coordinate pair to set of radius cells
function Radius:append(x, y)
    if not self.cells[x] then self.cells[x] = {} end
    self.cells[x][y] = true
end

-- return the set of cells adjacent to the specified cell
function Radius.near(x, y)
    return {
        {x = x + 1, y = y},
        {x = x - 1, y = y},
        {x = x, y = y + 1},
        {x = x, y = y - 1},
    }
end

-- filter to cells that are reachable with `move` movement points
function Radius.reachable(cells, move)
    local reach = {}
    for _, cell in pairs(cells) do
        if move >= cell.move then add(reach, cell) end
    end
    return reach
end

-- return true if x,y is among the cells within the radius
function Radius:contains(x, y)
    return self.cells[x] and self.cells[x][y]
end

-- reset the radius coordinates
function Radius:clear()
    self.cells = {}
    self.radius = nil
end

-- draw the radius to the map
function Radius:draw()
    for x, cell in pairs(self.cells) do
        for y, _ in pairs(cell) do spr(48, x * 8, y * 8) end
    end
end

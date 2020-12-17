Radius = {cells = {}, center = {x = nil, y = nil}, radius = nil}

-- draw a radius at the specified coordinates
function Radius:update(x, y, r)
    -- clear the prior radius
    self:clear()

    -- assign new property values
    self.center.x = x
    self.center.y = y
    self.radius = r

    -- algo starts
    self:append(self.center.x + self.radius, self.center.y)
    self:append(self.center.x - self.radius, self.center.y)
    self:append(self.center.x, self.center.y + self.radius)
    self:append(self.center.x, self.center.y - self.radius)
end

-- append the specified coordinate pair to set of radius cells
function Radius:append(x, y)
    if not self.cells[x] then self.cells[x] = {} end

    self.cells[x][y] = true
end

-- return true if x,y is among the cells within the radius
function Radius:contains(x, y)
    return self.cells[x] and self.cells[x][y]
end

-- reset the radius coordinates
function Radius:clear()
    self.cells = {}
    self.center = {}
    self.radius = nil
end

-- draw the radius to the map
function Radius:draw()
    for x, cell in pairs(self.cells) do
        for y, _ in pairs(cell) do spr(48, x * 8, y * 8) end
    end
end
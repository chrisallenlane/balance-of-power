Radius = {center = {x = nil, y = nil}, radius = nil}

-- draw a radius at the specified coordinates
function Radius:update(x, y, r)
    self.center.x = x
    self.center.y = y
    self.radius = r
end

-- reset the radius coordinates
function Radius:clear()
    self.center = {}
    self.radius = nil
end

function Radius:draw()
    if not self.center.x or not self.center.y then return end
    spr(48, (self.center.x + self.radius) * 8, self.center.y * 8)
    spr(48, (self.center.x - self.radius) * 8, self.center.y * 8)
    spr(48, self.center.x * 8, (self.center.y + self.radius) * 8)
    spr(48, self.center.x * 8, (self.center.y - self.radius) * 8)
end

-- encapsulate camera state
Camera = {}

function Camera:new()
    local c = {cell = {x = 0, y = 0}, px = {x = 0, y = 0}}
    setmetatable(c, self)
    self.__index = self
    return c
end

-- update camera state
function Camera:update()
    -- ensure that the camera is not at a fractional coordinate, and compute
    -- the destination
    local x, y, destx, desty = flr(self.px.x), flr(self.px.y), self.cell.x * 8,
                               self.cell.y * 8

    -- move toward the destination
    x = x < destx and x + 1 or x > destx and x - 1 or x
    y = y < desty and y + 1 or y > desty and y - 1 or y
    self.px = {x = x, y = y}
end

-- focus the camera on the specified grid position
function Camera:focus(x, y, state)
    local w, h = state.stage.cell.w, state.stage.cell.h

    -- Apply offsets to center on the specified coordinates. (An offset of 8
    -- is being applied because the screen is 16 cells wide.)
    x, y = x - 8, y - 8

    -- constrain
    x = x < 0 and 0 or x > w - 16 and w - 16 or x
    y = y < 0 and 0 or y > h - 16 and h - 16 or y

    -- TODO: this needs to be refined
    -- if the adjustment to make is minor, don't bother
    if (abs(self.cell.x - x) < 4) and (abs(self.cell.y - y) < 4) then return end

    -- update the camera position
    self.cell.x, self.cell.y = x, y
end

-- immediately move the camera to the specified cell coordinates
function Camera:warp(x, y)
    self.cell.x, self.cell.y = x, y
    self.px.x, self.px.y = x * 8, y * 8
end

-- move the game camera
function Camera:draw()
    camera(self.px.x, self.px.y)
end

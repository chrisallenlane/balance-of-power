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
    -- ensure that the camera is not at a fractional coordinate
    self.px.x, self.px.y = flr(self.px.x), flr(self.px.y)

    -- move toward the destination
    local destx, desty = self.cell.x * 8, self.cell.y * 8

    if self.px.x < destx then
        self.px.x = self.px.x + 1
    elseif self.px.x > destx then
        self.px.x = self.px.x - 1
    end

    if self.px.y < desty then
        self.px.y = self.px.y + 1
    elseif self.px.y > desty then
        self.px.y = self.px.y - 1
    end
end

-- focus the camera on the specified grid position
function Camera:focus(x, y, state)
    local w, h = state.stage.cell.w, state.stage.cell.h

    -- Apply offsets to center on the specified coordinates. (An offset of 8
    -- is being applied because the screen is 16 cells wide.)
    x, y = x - 8, y - 8

    -- constrain x
    if x < 0 then
        x = 0
    elseif x > w - 16 then
        x = w - 16
    end

    -- constrain y
    if y < 0 then
        y = 0
    elseif y > h - 16 then
        y = h - 16
    end

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

-- encapsulate camera state
Camera = {}

function Camera:new()
    local c = {cell = {x = 0, y = 0}, px = {x = 0, y = 0}}
    setmetatable(c, self)
    self.__index = self
    return c
end

-- update camera state
function Camera:update(state)
    local cursor, stage = state.player.cursor, state.stage

    -- track camera position as cell coordinates, and compare those coordinates
    -- to the cursor and screen position.
    -- right/left
    if cursor.cell.x - self.cell.x > 11 and self.cell.x < stage.cell.w - 16 then
        self.cell.x = self.cell.x + 1
    elseif self.cell.x > 0 and cursor.cell.x - self.cell.x < 4 then
        self.cell.x = self.cell.x - 1
    end

    -- down/up
    if cursor.cell.y - self.cell.y > 11 and self.cell.y < stage.cell.h - 16 then
        self.cell.y = self.cell.y + 1
    elseif self.cell.y > 0 and cursor.cell.y - self.cell.y < 4 then
        self.cell.y = self.cell.y - 1
    end

    -- Track camera pixel position. Ease toward the cell coordinates to make
    -- scrolling look smoother.
    if self.px.x < self.cell.x * 8 then
        self.px.x = self.px.x + 4
    elseif self.px.x > self.cell.x * 8 then
        self.px.x = self.px.x - 4
    end

    if self.px.y < self.cell.y * 8 then
        self.px.y = self.px.y + 4
    elseif self.px.y > self.cell.y * 8 then
        self.px.y = self.px.y - 4
    end
end

-- focus the camera on the specified grid position
-- TODO: parameterize wiggle?
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

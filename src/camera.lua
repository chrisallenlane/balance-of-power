-- encapsulate camera state
Camera = {cell = {x = 0, y = 0}, px = {x = 0, y = 0}}

-- update camera state
function Camera:update()
    -- if a unit is being animated, do not allow the
    -- camera to move
    if Lock.unit then return end

    -- prevent the camera from moving immediately if a unit has just moved
    Lock.camera = true
    if Delay.unit > 0 then
        Delay.unit = Delay.unit - 1
        return
    end

    -- unlock the cursor
    Lock.camera = false

    -- track camera position as cell coordinates, and compare those coordinates
    -- to the cursor and screen position.
    local cur = Cursor

    -- right/left
    if cur.move.r and cur.cell.x - self.cell.x > 11 and self.cell.x <
        Game.map.cell.w - 16 then
        self.cell.x = self.cell.x + 1
    elseif cur.move.l and self.cell.x > 0 and cur.cell.x - self.cell.x < 4 then
        self.cell.x = self.cell.x - 1
    end

    -- down/up
    if cur.move.d and cur.cell.y - self.cell.y > 11 and self.cell.y <
        Game.map.cell.h - 16 then
        self.cell.y = self.cell.y + 1
    elseif cur.move.u and self.cell.y > 0 and cur.cell.y - self.cell.y < 4 then
        self.cell.y = self.cell.y - 1
    end

    -- Track camera pixel position. Ease toward the cell coordinates to make
    -- scrolling look smoother.
    if self.px.x < self.cell.x * 8 then
        self.px.x = self.px.x + 4
        Lock.camera = true
    elseif self.px.x > self.cell.x * 8 then
        self.px.x = self.px.x - 4
        Lock.camera = true
    end

    if self.px.y < self.cell.y * 8 then
        self.px.y = self.px.y + 4
        Lock.camera = true
    elseif self.px.y > self.cell.y * 8 then
        self.px.y = self.px.y - 4
        Lock.camera = true
    end
end

-- move the game camera
function Camera:draw()
    camera(self.px.x, self.px.y)
end

-- move the camera to the specified grid position
function Camera:focus(x, y, w, h)
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

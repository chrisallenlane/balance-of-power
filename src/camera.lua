-- encapsulate camera state
Game.camera = {cell = {x = 0, y = 0}, px = {x = 0, y = 0}}

-- update camera state
function Game.camera:update()
    -- if a unit is being animated, do not allow the
    -- camera to move
    if Game.lock.unit then return end

    -- prevent the camera from moving immediately if a unit has just moved
    Game.lock.camera = true
    if Game.delay.unit > 0 then
        Game.delay.unit = Game.delay.unit - 1
        return
    end

    -- unlock the cursor
    Game.lock.camera = false

    -- track camera position as cell coordinates, and compare those coordinates
    -- to the cursor and screen position.
    local cur = Game.cursor

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
        Game.lock.camera = true
    elseif self.px.x > self.cell.x * 8 then
        self.px.x = self.px.x - 4
        Game.lock.camera = true
    end

    if self.px.y < self.cell.y * 8 then
        self.px.y = self.px.y + 4
        Game.lock.camera = true
    elseif self.px.y > self.cell.y * 8 then
        self.px.y = self.px.y - 4
        Game.lock.camera = true
    end
end

-- move the game camera
function Game.camera:draw()
    camera(self.px.x, self.px.y)
end

-- move the camera to the specified grid position
function Game.camera:focus(x, y, w, h)
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

-- encapsulate camera state
game.camera = {cell = {x = 0, y = 0}, px = {x = 0, y = 0}}

-- update camera state
function game.camera:update()

    -- track camera position as cell coordinates, and compare those coordinates
    -- to the cursor and screen position.

    -- right
    if game.cursor.move.r and game.cursor.cell.x - self.cell.x > 11 and
        self.cell.x < game.map.cell.w - 16 then self.cell.x = self.cell.x + 1 end

    -- left
    if game.cursor.move.l and self.cell.x > 0 and game.cursor.cell.x -
        self.cell.x < 4 then self.cell.x = self.cell.x - 1 end

    -- down
    if game.cursor.move.d and game.cursor.cell.y - self.cell.y > 11 and
        self.cell.y < game.map.cell.h - 16 then self.cell.y = self.cell.y + 1 end

    -- up
    if game.cursor.move.u and self.cell.y > 0 and game.cursor.cell.y -
        self.cell.y < 4 then self.cell.y = self.cell.y - 1 end

    -- Track camera pixel position. Ease toward the cell coordinates to make
    -- scrolling look smoother.
    if self.px.x < self.cell.x * 8 then self.px.x = self.px.x + 2 end
    if self.px.x > self.cell.x * 8 then self.px.x = self.px.x - 2 end
    if self.px.y < self.cell.y * 8 then self.px.y = self.px.y + 2 end
    if self.px.y > self.cell.y * 8 then self.px.y = self.px.y - 2 end
end

-- move the game camera
function game.camera:draw()
    camera(self.px.x, self.px.y)
end

-- move the camera to the specified grid position
function game.camera:focus(x, y, w, h)
    -- Apply offsets to center on the specified coordinates. (An offset of 8
    -- is being applied because the screen is 16 cells wide.)
    x, y = x - 8, y - 8

    -- apply constraints to x coordinate
    if x < 0 then
        x = 0
    elseif x > w - 16 then
        x = w - 16
    end

    -- apply constraints to y coordinate
    if y < 0 then
        y = 0
    elseif y > h - 16 then
        y = h - 16
    end

    -- update the camera position
    self.cell.x, self.cell.y = x, y
end

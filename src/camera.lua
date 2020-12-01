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
function game.camera:move()
    camera(self.px.x, self.px.y)
end

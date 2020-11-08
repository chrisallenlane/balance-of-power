-- encapsulate camera state
game.camera = {cell = {x = 0, y = 0}, p = {x = 0, y = 0}}

-- update camera state
function game.camera:update()

    -- track camera position as cell coordinates, and compare those coordinates
    -- to the cursor and screen position.

    -- right
    if game.cursor.direction == "right" and game.cursor.cell.x - self.cell.x >
        11 and self.cell.x < game.map.cell.w - 16 then
        self.cell.x = self.cell.x + 1
    end

    -- left
    if game.cursor.direction == "left" and self.cell.x > 0 and
        game.cursor.cell.x - self.cell.x < 4 then
        self.cell.x = self.cell.x - 1
    end

    -- down
    if game.cursor.direction == "down" and game.cursor.cell.y - self.cell.y > 11 and
        self.cell.y < game.map.cell.h - 16 then self.cell.y = self.cell.y + 1 end

    -- up
    if game.cursor.direction == "up" and self.cell.y > 0 and game.cursor.cell.y -
        self.cell.y < 4 then self.cell.y = self.cell.y - 1 end

    -- Track camera pixel position. Ease toward the cell coordinates to make
    -- scrolling look smoother.
    if self.p.x < self.cell.x * 8 then self.p.x = self.p.x + 2 end
    if self.p.x > self.cell.x * 8 then self.p.x = self.p.x - 2 end
    if self.p.y < self.cell.y * 8 then self.p.y = self.p.y + 2 end
    if self.p.y > self.cell.y * 8 then self.p.y = self.p.y - 2 end
end

-- move the game camera
function game.camera:move()
    camera(self.p.x, self.p.y)
end

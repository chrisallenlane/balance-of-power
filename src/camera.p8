-- encapsulate camera state
game.camera = {
  celx = 0,
  cely = 0,
  px   = 0,
  py   = 0,
}

-- update camera state
function game.camera:update()

  -- track camera position as cell coordinates, and compare those coordinates
  -- to the cursor and screen position.

  -- right
  if game.cursor.direction == "right"
    and game.cursor.celx - self.celx > 11
    and self.celx < game.map.celw-16
  then
    self.celx += 1
  end

  -- left
  if game.cursor.direction == "left"
    and self.celx > 0
    and game.cursor.celx - self.celx < 4
  then
    self.celx -= 1
  end

  -- down
  if game.cursor.direction == "down"
    and game.cursor.cely - self.cely > 11
    and self.cely < game.map.celh-16
  then
    self.cely += 1
  end

  -- up
  if game.cursor.direction == "up"
    and self.cely > 0
    and game.cursor.cely - self.cely < 4
  then
    self.cely -= 1
  end

  -- Track camera pixel position. Ease toward the cell coordinates to make
  -- scrolling look smoother.
  if self.px < self.celx*8 then
    self.px += 2
  end
  if self.px > self.celx*8 then
    self.px -= 2
  end
  if self.py < self.cely*8 then
    self.py += 2
  end
  if self.py < self.cely*8 then
    self.py -= 2
  end
end

-- move the game camera
function game.camera:move()
  camera(self.px, self.py)
end

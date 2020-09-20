-- BUG: cursor can outrun camera

-- encapsulate camera state
-- NB: x and y are pixel coordinates
game.camera = {
  x = 0,
  y = 0,
}

-- update camera state
function game.camera:update()

  -- TODO: short-circuit if map fits entirely within single screen

  -- right
  if game.cursor.direction == "right"
    and game.cursor.x*8 - self.x > 88
  then
    self.x += 1
  end

  -- left
  if game.cursor.direction == "left"
    and self.x > 0
    and game.cursor.x*8 - self.x < 24
  then
    self.x -= 1
  end

  -- down
  if game.cursor.direction == "down"
    and game.cursor.y*8 - self.y > 88
  then
    self.y += 1
  end

  -- up
  if game.cursor.direction == "up"
    and self.y > 0
    and game.cursor.y*8 - self.y < 24
  then
    self.y -= 1
  end
end

-- move the game camera
function game.camera:move()
  camera(self.x, self.y)
end

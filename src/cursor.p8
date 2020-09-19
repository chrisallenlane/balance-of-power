-- encapsulate cursor state
game.cursor = {
  x = 0,
  y = 0,
  direction = "stop",
}

-- update cursor state
function game.cursor:update()
  -- left
  if btnp(0) and self.x >= 8 then
    self.direction = "left"
    self.x -= 8
  end

  -- right
  if btnp(1) and self.x < game.map.width+8 then
    self.direction = "right"
    self.x += 8
  end

  -- up
  if btnp(2) and self.y >= 8 then
    self.direction = "up"
    self.y -= 8
  end

  -- down
  if btnp(3) and self.y < game.map.height+8 then
    self.direction = "down"
    self.y += 8
  end
end

-- render the cursor
function game.cursor:draw()
  spr(7, self.x, self.y)
end

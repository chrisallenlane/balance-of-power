-- encapsulate cursor state
-- NB: x and y are grid coordinates
game.cursor = {
  x = 0,
  y = 0,
  direction = "stop",
  tile = 0
}

-- update cursor state
function game.cursor:update()
  -- left
  if btnp(0) and self.x > 0 then
    self.direction = "left"
    self.x -= 1
  end

  -- right
  if btnp(1) and self.x < (game.maps[game.map.number].celw-1) then
    self.direction = "right"
    self.x += 1
  end

  -- up
  if btnp(2) and self.y > 0 then
    self.direction = "up"
    self.y -= 1
  end

  -- down
  if btnp(3) and self.y < (game.maps[game.map.number].celh-1) then
    self.direction = "down"
    self.y += 1
  end

  -- calculate the tile on which the cursor is resting
  self.tile = self.y*game.maps[game.map.number].celw + self.x
end

-- render the cursor
function game.cursor:draw()
  spr(7, self.x*8, self.y*8)
end

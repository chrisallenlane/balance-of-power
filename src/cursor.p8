-- encapsulate cursor state
game.cursor = {
  celx = 0,
  cely = 0,
  direction = "stop",
  tile = 0,
}

-- update cursor state
function game.cursor:update()

  -- left
  if btnp(0) and self.celx > 0 then
    self.direction = "left"
    self.celx = self.celx-1
  end

  -- right
  if btnp(1) and self.celx < game.map.celw-1 then
    self.direction = "right"
    self.celx = self.celx+1
  end

  -- up
  if btnp(2) and self.cely > 0 then
    self.direction = "up"
    self.cely = self.cely-1
  end

  -- down
  if btnp(3) and self.cely < game.map.celh-1 then
    self.direction = "down"
    self.cely = self.cely+1
  end

  -- calculate the tile on which the cursor is resting
  self.tile = self.cely*game.map.celw + self.celx
end

-- render the cursor
function game.cursor:draw()
  spr(7, self.celx*8, self.cely*8)
end

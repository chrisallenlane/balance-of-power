-- encapsulate cursor state
game.cursor = {
  celx = 0,
  cely = 0,
  direction = "stop",
  tile = 0,

  btn_0 = 3,
  btn_1 = 3,
  btn_2 = 3,
  btn_3 = 3,
}

-- update cursor state
function game.cursor:update()
  
  -- don't register a re-press until `frame` frames
  local frame = 4

  -- left
  if btn(0) and self.celx > 0 then
    self.direction = "left"
    self.btn_0 = self.btn_0+1
    if self.btn_0 >= frame then
      self.btn_0 = 0
      self.celx = self.celx-1
    end
  elseif not btn(0) then
    self.btn_0 = frame-1
  end

  -- right
  if btn(1) and self.celx < game.map.celw-1 then
    self.direction = "right"
    self.btn_1 = self.btn_1+1
    if self.btn_1 >= frame then
      self.btn_1 = 0
      self.celx = self.celx+1
    end
  elseif not btn(1) then
    self.btn_1 = frame-1
  end

  -- up
  if btn(2) and self.cely > 0 then
    self.direction = "up"
    self.btn_2 = self.btn_2+1
    if self.btn_2 >= frame then
      self.btn_2 = 0
      self.cely = self.cely-1
    end
  elseif not btn(2) then
    self.btn_2 = frame-1
  end
 
  -- down
  if btn(3) and self.cely < game.map.celh-1 then
    self.direction = "down"
    self.btn_3 = self.btn_3+1
    if self.btn_3 >= frame then
      self.btn_3 = 0
      self.cely = self.cely+1
    end
  elseif not btn(3) then
    self.btn_3 = frame-1
  end

  -- calculate the tile on which the cursor is resting
  self.tile = self.cely*game.map.celw + self.celx
end

-- render the cursor
function game.cursor:draw()
  spr(7, self.celx*8, self.cely*8)
end

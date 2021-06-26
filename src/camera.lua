-- encapsulate camera state
Camera = {}

function Camera:new()
  local c = {cellx = 0, celly = 0, pxx = 0, pxy = 0}
  setmetatable(c, self)
  self.__index = self
  return c
end

-- update camera state
function Camera:update()
  -- ensure that the camera is not at a fractional coordinate, and compute
  -- the destination
  local x, y, destx, desty = self.pxx, self.pxy, self.cellx * 8, self.celly * 8

  -- move toward the destination
  self.pxx = x < destx and x + 1 or x > destx and x - 1 or x
  self.pxy = y < desty and y + 1 or y > desty and y - 1 or y
end

-- follow the cursor
function Camera:follow(state)
  local cur, stage = state.player.cursor, state.stage
  local curx, cury, camx, camy = cur.cellx, cur.celly, self.cellx, self.celly

  -- horizonal
  if curx >= camx + 12 and camx < stage.cellw - 16 then
    self.cellx = camx + 1
  elseif curx <= camx + 4 and camx > 0 then
    self.cellx = camx - 1
  end

  -- vertical
  if cury >= camy + 12 and camy < stage.cellh - 16 then
    self.celly = camy + 1
  elseif cury <= camy + 4 and camy > 0 then
    self.celly = camy - 1
  end
end

-- focus the camera on the specified grid position
function Camera:focus(x, y, state)
  local w, h = state.stage.cellw, state.stage.cellh

  -- Apply offsets to center on the specified coordinates. (An offset of 8
  -- is being applied because the screen is 16 cells wide.)
  x, y = x - 8, y - 8

  -- constrain
  x = x < 0 and 0 or x > w - 16 and w - 16 or x
  y = y < 0 and 0 or y > h - 16 and h - 16 or y

  -- calculate the difference from the current and new camera positions
  local deltaX, deltaY = abs(self.cellx - x), abs(self.celly - y)

  -- calculate which cells are now on screen
  local boundX, boundY = self.cellx + 15, self.celly + 15

  -- if the adjustment to make is minor, don't bother - as long as the focus
  -- cell is still onscreen!
  if deltaX < 4 and deltaY < 4 and x >= self.cellx and x <= boundX and y >=
    self.celly and y <= boundY then return end

  -- update the camera position
  self.cellx, self.celly = x, y
end

-- immediately move the camera to the specified cell coordinates
function Camera:warp(x, y)
  self.cellx, self.celly = x, y
  self.pxx, self.pxy = x * 8, y * 8
end

-- move the game camera
function Camera:draw()
  camera(self.pxx, self.pxy)
end

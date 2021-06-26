Cursor = {}

function Cursor:new()
  local c = {
    -- current cursor cell position
    cellx = 0,
    celly = 0,

    -- the currently selected unit
    -- @todo: remove the `unit` wrapper if I never add additional properties
    -- @todo: possibly move this to player.unitSelected or something
    unit = {sel = nil},

    -- is the cursor visible?
    vis = true,

    -- frame counter used for animations
    frame = 0,
  }

  setmetatable(c, self)
  self.__index = self
  return c
end

-- update cursor state
function Cursor:update(stage, inputs)
  -- left/right
  if inputs.left:rep() and self.cellx > 0 then
    self.cellx = self.cellx - 1
  elseif inputs.right:rep() and self.cellx < stage.cellw - 1 then
    self.cellx = self.cellx + 1
  end

  -- up/down
  if inputs.up:rep() and self.celly > 0 then
    self.celly = self.celly - 1
  elseif inputs.down:rep() and self.celly < stage.cellh - 2 then
    self.celly = self.celly + 1
  end
end

-- @todo: move this into unit state
-- Return true if `unit` unit is selected, or true if any unit is selected
-- otherwise
function Cursor:selected(unit)
  if unit then return self.unit.sel and (self.unit.sel == unit) end
  return self.unit.sel
end

-- render the cursor
-- NB: if I become desperate tokens, I can eliminate the cursor "throb"
function Cursor:draw(state)
  -- end early if the cursor should not be visible
  if not self.vis or not Seq:done() or state.talk.vis then return end

  -- choose the appropriate sprite
  local sprite = 1
  if self.frame < 30 then
    sprite = 2
  elseif self.frame > 60 then
    self.frame = 0
  end

  -- increment the frame counter
  self.frame = self.frame + 1

  -- draw the sprite
  spr(sprite, self.cellx * 8, self.celly * 8)
end

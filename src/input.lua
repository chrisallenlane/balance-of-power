Input = {}

-- Input constructor
function Input:new(btn)
  local i = {btn = btn}

  setmetatable(i, self)
  self.__index = self

  -- instance properties
  i.frame, i.wait, i.pressed = 1, 8, {cur = false, prev = false}

  return i
end

-- Implement functionality similar to `btnp`, but with a shorter spin-up time
-- TODO: replace with `poke`?
-- https://pico-8.fandom.com/wiki/Btnp?commentId=4400000000000075907
function Input:rep()
  -- if the button was not pressed, set the frame counter to `wait` minus 1.
  -- This ensures that a key press is registered when the key is initially
  -- pressed.
  if not self.pressed.cur then
    self.frame = self.wait - 1
    return false
  end

  -- increment the frame counter
  self.frame = self.frame + 1

  -- if we've waited long enough, reset the counter and return true
  if self.frame >= self.wait then
    self.frame = 1
    return true
  end

  return false
end

-- Implement functionality similar to `btnp`, but without repetition
function Input:once()
  return not self.pressed.prev and self.pressed.cur
end

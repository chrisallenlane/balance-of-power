Seq = {}

-- initializer
function Seq:new()
  local s = {queue = {}}
  setmetatable(s, self)
  self.__index = self
  return s
end

-- enqueue animations
function Seq:add(fns)
  for _, fn in ipairs(fns) do add(self.queue, fn) end
end

-- play animations
function Seq:play()
  -- otherwise, play the sequence at the front of the queue
  if self.queue[1] and self.queue[1]() ~= false then
    -- if the sequence has completed, remove it from the queue
    deli(self.queue, 1)
  end
end

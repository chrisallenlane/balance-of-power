Seq = {
  -- the sequence queue
  queue = {},
}

-- enqueue animations
function Seq:enqueue(fns)
  for _, fn in ipairs(fns) do add(self.queue, fn) end
end

-- play animations
function Seq:play()
  -- if there are no sequences in the queue, return false ("not playing")
  if #self.queue == 0 then return end

  -- otherwise, play the sequence at the front of the queue
  if (self.queue[1]() ~= false) then
    -- if the sequence has completed, remove it from the queue
    deli(self.queue, 1)
  end
end

function Seq:done()
  return #self.queue == 0
end

-- clear animations
function Seq:clear()
  self.queue = {}
end

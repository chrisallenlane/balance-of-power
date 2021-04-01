Seq = {
    -- the sequence queue
    queue = {},
}

-- TODO: accept an array of functions
function Seq:enqueue(fn)
    add(self.queue, fn)
end

function Seq:play()
    -- if there are no sequences in the queue, return false ("not playing")
    if #self.queue == 0 then return false end

    -- otherwise, play the sequence at the front of the queue
    if (self.queue[1]()) then
        -- if the sequence has completed, remove it from the queue
        deli(self.queue, 1)
    end

    -- indicate that an sequence is currently being played
    return true
end
Anim = {
    -- the animation queue
    queue = {},
}

-- TODO: accept an array of functions
function Anim:enqueue(fn)
    add(self.queue, fn)
end

function Anim:play()
    -- if there are no animations in the queue, return false ("not playing")
    if #self.queue == 0 then return false end

    -- otherwise, play the animation at the front of the queue
    if (self.queue[1]()) then
        -- if the animation has completed, remove it from the queue
        deli(self.queue, 1)
    end

    -- indicate that an animation is currently being played
    return true
end

-- initialize the class metatable
Anim = {}

-- delay `delay` frames
function Anim.delay(frames)
    local d = {frames = frames}
    return function()
        d.frames = d.frames - 1
        if d.frames == 0 then
            return true
        else
            return false
        end
    end
end

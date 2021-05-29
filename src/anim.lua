--[[
Anim implements game animations.
]] -- initialize the class metatable
Anim = {}

--[[--
Delay an arbitrary number of frames
@param frames The number of frames to delay
@return done `true` if the delay is complete; `false` otherwise
]] --
function Anim.delay(frames)
    return function()
        frames = frames - 1
        return frames == 0
    end
end

--[[--
Return the number of steps to take from `src` to `dst` at `speed` in a
single frame.
@param src The source coordinate (1-dimensional)
@param dst The destination coordinate (1-dimensional)
@param speed The rate at which to move from `src` to `dst`
@return The step size to take
]] --
function Anim.step(src, dst, speed)
    local delta = dst - src

    if delta >= 0 then return speed < delta and speed or delta end

    return -(speed < delta and delta or speed)
end

--[[--
Translate an object across the stage
@param obj The object to translate
@param x The x-coordinate destination
@param y The y-coordinate destination
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.trans(obj, x, y)
    -- warp the object to the specified cell
    obj.cell.x, obj.cell.y = x, y

    -- animate the pixel location enclosing on the cell location
    return function()
        local px, py, destx, desty = obj.px.x, obj.px.y, obj.cell.x * 8,
                                     obj.cell.y * 8

        -- conclude the animation if the object has reached its destination
        if px == destx and py == desty then return true end

        obj.px = {
            x = obj.px.x + Anim.step(px, destx, 4),
            y = obj.px.y + Anim.step(py, desty, 4),
        }

        return false
    end
end

--[[--
Fire a laser from `src` to `dst`
@param src The laser origin
@param dst The laser destination
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.laser(src, dst)
    -- animation duration
    local frame = 0

    return function()
        -- end the animation after the specified number of frames
        if frame == 20 then return true end

        -- fire the laser!
        local color = frame % 3 == 0 and 7 or frame % 2 == 0 and 10 or 0
        line(src.px.x + 3, src.px.y + 3, dst.px.x + 3, dst.px.y + 3, color)

        -- continue the animation
        frame = frame + 1
        return false
    end
end

--[[--
Explode `unit`
@param unit The unit to explode.
@param state The game state.
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.explode(unit, state)
    local frame = 0

    return function()
        -- end the animation after the specified number of frames
        if frame == 12 then return true end

        -- shake the camera
        state.camera.px.x = state.camera.px.x + (frame % 2 == 0 and -2 or 2)

        -- draw the explosion
        circfill(unit.px.x + 2, unit.px.y + 2, 1.5 * frame,
                 split("7,10,9")[frame % 7])

        -- continue the animation
        frame = frame + 1
        return false
    end
end

--[[--
Repair `unit`
@param unit The unit to repair.
@param state The game state (unused)
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.repair(unit, _)
    local frame = 15

    return function()
        -- end the animation after the specified number of frames
        if frame == 0 then return true end

        -- draw repair halos
        circ(unit.px.x + 3, unit.px.y + 3, frame % 5 * 2.5,
             frame % 2 == 0 and 12 or 2)

        -- continue the animation
        frame = frame - 1
        return false
    end
end

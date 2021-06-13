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
    obj.cellx, obj.celly = x, y

    -- animate the pixel location enclosing on the cell location
    return function()
        local destx, desty = obj.cellx * 8, obj.celly * 8

        -- conclude the animation if the object has reached its destination
        if obj.pxx == destx and obj.pxy == desty then return true end

        obj.pxx = obj.pxx + Anim.step(obj.pxx, destx, 4)
        obj.pxy = obj.pxy + Anim.step(obj.pxy, desty, 4)

        return false
    end
end

--[[--
Fire a laser from `src` to `dst`
@param attacker The attacking ship
@param target The targeted ship
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.laser(attacker, target)
    -- animation duration
    local frame = 0

    -- randomly choose an attacker and target ship
    local as, ts = rnd(attacker:swarm()) + 1, rnd(target:swarm()) + 1

    return function()
        -- end the animation after the specified number of frames
        if frame == 20 then
            attacker.step, target.step = 0.001, 0.001
            return true
        end

        -- speed up the unit rotations
        attacker.step, target.step = 0.01, 0.01

        -- get ship coordinates
        local ax, ay = attacker:ship(as)
        local tx, ty = target:ship(ts)

        -- fire the laser!
        local color = frame % 3 == 0 and 7 or frame % 2 == 0 and 10 or 0
        line(ax + 1, ay, tx + 1, ty, color)

        -- draw a blast
        Anim.blast(tx + 1, ty, 0.20 * frame, frame)

        -- continue the animation
        frame = frame + 1
        return false
    end
end

--[[--
Explode `unit`
@param x The `x` position of the explosion center
@param y The `y` position of the explosion center
@param state The game state.
@return done `true` if the animation is complete; `false` otherwise
]] --
function Anim.explode(x, y, state)
    local frame = 0

    return function()
        -- end the animation after the specified number of frames
        if frame == 12 then return true end

        -- shake the camera
        state.camera.pxx = state.camera.pxx + (frame % 2 == 0 and -2 or 2)

        -- draw the explosion
        Anim.blast(x + 2, y + 2, 1.5 * frame, frame)

        -- continue the animation
        frame = frame + 1
        return false
    end
end

--[[--
Draw a (single-frame) blast
@param x The x coordinate of center
@param y The y coordinate of center
@param frame The animation frame
]] --
function Anim.blast(x, y, r, frame)
    circfill(x, y, r, split("7,10,9")[frame % 7])
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
        circ(unit.pxx + 3, unit.pxy + 3, frame % 5 * 2.5,
             frame % 2 == 0 and 12 or 2)

        -- continue the animation
        frame = frame - 1
        return false
    end
end

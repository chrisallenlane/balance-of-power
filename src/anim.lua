-- initialize the class metatable
Anim = {}

-- delay `delay` frames
function Anim.delay(frames)
    return function()
        frames = frames - 1
        return frames == 0
    end
end

-- return the number of steps to take from `src` to `dst` at `speed` in a
-- single frame.
function Anim.step(src, dst, speed)
    local delta = dst - src

    if delta >= 0 then return speed < delta and speed or delta end

    return -(speed < delta and delta or speed)
end

-- translate an object across the stage
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

-- fire a laser from `src` to `dst`
function Anim.laser(src, dst)
    -- animation duration
    local frames = 20

    return function()
        -- hide the attacking unit's radii
        src.radius.vis = false

        -- end the animation after `frames` frames
        if frames == 0 then
            -- TODO: hide the opponent's radii?
            src.radius.vis = true
            return true
        end

        -- fire the laser!
        line(src.px.x + 3, src.px.y + 3, dst.px.x + 3, dst.px.y + 3, 7 + rnd(3))

        -- continue the animation
        frames = frames - 1
        return false
    end
end

-- explode `unit`
function Anim.explode(unit, state)
    local cam, frames = state.camera, 0
    -- TODO: can can _probably_ remove `orig` once I fix the camera bugs
    local orig = {x = cam.px.x, y = cam.px.y}

    return function()
        -- end the animation after `frames` frames
        if frames == 15 then
            cam.px = orig
            return true
        end

        -- shake the camera
        for _, c in ipairs({"x", "y"}) do
            cam.px[c] = cam.px[c] + flr(2 - rnd(3))
            if cam.px[c] < 0 then cam.px[c] = 0 end
        end

        -- draw the explosion
        local cx, cy = unit.px.x + 3, unit.px.y + 3
        circfill(cx, cy, frames, 9)
        circ(cx, cy, frames * 2 + 1, 10)
        circ(cx, cy, frames * 2 + 2, 7)

        -- continue the animation
        frames = frames + 1
        return false
    end
end

-- repair `unit`
function Anim.repair(unit, state)
    local cam, frames = state.camera, 0
    -- TODO: can can _probably_ remove `orig` once I fix the camera bugs
    local orig = {x = cam.px.x, y = cam.px.y}

    return function()
        -- end the animation after `frames` frames
        if frames == 15 then
            cam.px = orig
            return true
        end

        -- draw the explosion
        local cx, cy = unit.px.x + 3, unit.px.y + 3
        circ(cx, cy, frames * 2 + 1, 12)

        -- continue the animation
        frames = frames + 1
        return false
    end
end

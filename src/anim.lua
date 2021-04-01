-- initialize the class metatable
Anim = {}

-- delay `delay` frames
function Anim.delay(frames)
    local d = {frames = frames}
    return function()
        d.frames = d.frames - 1
        return d.frames == 0
    end
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

        -- x
        if px < destx then
            obj.px.x = px + 4
        elseif px > destx then
            obj.px.x = px - 4
        end

        -- y
        if py < desty then
            obj.px.y = py + 4
        elseif py > desty then
            obj.px.y = py - 4
        end

        return false
    end
end

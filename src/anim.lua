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
        -- conclude the animation if the object has reached its destination
        if obj.px.x == obj.cell.x * 8 and obj.px.y == obj.cell.y * 8 then
            return true
        end

        -- x
        if obj.px.x < obj.cell.x * 8 then
            obj.px.x = obj.px.x + 4
        elseif obj.px.x > obj.cell.x * 8 then
            obj.px.x = obj.px.x - 4
        end

        -- y
        if obj.px.y < obj.cell.y * 8 then
            obj.px.y = obj.px.y + 4
        elseif obj.px.y > obj.cell.y * 8 then
            obj.px.y = obj.px.y - 4
        end

        return false
    end
end

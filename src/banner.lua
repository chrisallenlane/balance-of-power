Banner = {vis = false}

-- set, show, and hide the banner, then call a callback
function Banner:display(player, msg, delay, done)
    return function()
        -- assign banner properties
        self.msg, self.player, self.vis = msg, player, true

        -- wait `delay` frames to advance
        delay = delay - 1
        if delay ~= 0 then return false end

        -- hide the banner and call the callback
        self.vis = false
        done()

        return true
    end
end

function Banner:draw(state)
    if not self.vis then return end

    -- calculate padding to align with camera
    local px, py = state.camera.px.x, state.camera.px.y
    local xStart, xEnd = 0 + px, 128 + px

    -- choose the appropriate color for the winner
    local light, dark = 12, 1
    if self.player == 2 then dark, light = 8, 2 end

    -- draw the banner
    rectfill(0 + px, 45 + py, 128 + px, 70 + py, dark)
    line(xStart, 46 + py, xEnd, 46 + py, 7)
    line(xStart, 47 + py, xEnd, 47 + py, light)
    line(xStart, 68 + py, xEnd, 68 + py, light)
    line(xStart, 69 + py, xEnd, 69 + py, 7)
    String.centerX(self.msg, 55 + py, 7, state)
end

-- TODO: animate the banner?
Banner = {vis = false}

function Banner:show(player, msg)
    self.vis = true
    self.player = player
    self.msg = msg
end

function Banner:hide()
    self.vis = false
end

function Banner:draw(state)
    if not self.vis then return end

    -- calculate padding to align with camera
    local px = state.camera.px.x
    local py = state.camera.px.y

    -- choose the appropriate color for the winner
    local light, dark
    if self.player == 1 then
        dark, light = 1, 12
    else
        dark, light = 2, 8
    end

    -- draw the banner
    rectfill(0 + px, 45 + py, 128 + px, 70 + py, dark)
    line(0 + px, 46 + py, 128 + px, 46 + py, 7)
    line(0 + px, 47 + py, 128 + px, 47 + py, light)
    line(0 + px, 68 + py, 128 + px, 68 + py, light)
    line(0 + px, 69 + py, 128 + px, 69 + py, 7)
    String.centerX(self.msg, 55 + py, 7)
end

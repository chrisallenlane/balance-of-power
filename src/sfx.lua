SFX = {
    -- map effect names to a table of play parameters
    fx = {['power-up'] = {0, 0, 8}, ['power-down'] = {0, 8, 8}},
}

-- Play the specified sound effect
function SFX:play(fx)
    local effect = self.fx[fx][1]
    local offset = self.fx[fx][2]
    local length = self.fx[fx][3]
    sfx(effect, 3, offset, length)
end

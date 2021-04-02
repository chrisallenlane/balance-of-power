SFX = {
    -- TODO: represent this with fewer tokens!
    -- map effect names to a table of play parameters
    fx = {['power-up'] = {0, 0, 8}, ['power-down'] = {0, 8, 8}},
}

-- Play the specified sound effect
function SFX:play(name)
    local effect = self.fx[name]
    -- effect, channel, offset, length
    sfx(effect[1], 3, effect[2], effect[3])
end

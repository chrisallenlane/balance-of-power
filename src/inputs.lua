Inputs = {
    left = Input:new(0),
    right = Input:new(1),
    up = Input:new(2),
    down = Input:new(3),
    no = Input:new(4),
    yes = Input:new(5),
}

-- Poll the inputs. This runs once per update loop.
function Inputs:poll(player)
    local ins = {self.left, self.right, self.up, self.down, self.no, self.yes}

    for _, input in pairs(ins) do
        -- record button press state for the current and previous frame
        input.pressed.prev = input.pressed.cur
        input.pressed.cur = btn(input.btn, player - 1)
    end
end

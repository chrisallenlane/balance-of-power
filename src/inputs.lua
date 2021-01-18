Inputs = {BtnLeft, BtnRight, BtnUp, BtnDown, BtnX, BtnZ}

-- Poll the inputs. This runs once per update loop.
function Inputs:poll()
    for _, input in ipairs(self) do
        -- record button press state for the current and previous frame
        input.pressed.prev = input.pressed.cur
        input.pressed.cur = btn(input.btn)
    end
end

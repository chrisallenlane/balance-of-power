Menus.Title = {choices = {"1 player", "2 player"}, sel = 1}

function Menus.Title:update(state, inputs)
    self.sel = Menu.select(self, inputs)

    if inputs.yes:once() then
        -- flag P2 as a CPU if a 1-player game is selected
        if self.sel == 1 then state.players[2].cpu = true end

        -- load the first stage
        Stage.load(TITLE_STAGE, Stages, Screens, state)
    end
end

function Menus.Title:draw(_)
    local y = 50

    for i, choice in ipairs(self.choices) do
        local mark = "  "
        if i == self.sel then mark = "* " end
        print(mark .. choice, 20, y, 1)
        y = y + 10
    end
end

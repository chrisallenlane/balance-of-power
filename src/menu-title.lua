Menus.Title = {choices = {"1 player", "2 player", "skirmish"}, sel = 1}

function Menus.Title:update(state, inputs)
    -- up
    if inputs.up:once() and self.sel >= 2 then
        self.sel = self.sel - 1

        -- down
    elseif inputs.down:once() and self.sel <= 2 then
        self.sel = self.sel + 1

        -- "select"
    elseif inputs.yes:once() then
        -- flag P2 as a CPU if a 1-player game is selected
        if self.sel == 1 then state.players[2].cpu = true end

        -- load the map interstitial
        -- TODO: handle this differently in 2-player mode
        state.screen = Screens.intr
    end
end

function Menus.Title:draw(_)
    local y = 50

    for i, choice in ipairs(self.choices) do
        if i == self.sel then
            print("* " .. choice, 20, y, 1)
        else
            print("  " .. choice, 20, y, 1)
        end

        y = y + 10
    end
end

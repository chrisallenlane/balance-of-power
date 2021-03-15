-- update the title screen
function Screens.title.update(inputs)
    local menu = MenuScreenTitle
    local sel = menu.sel

    -- up
    if inputs.up:once() and sel >= 2 then
        menu.sel = sel - 1

        -- down
    elseif inputs.down:once() and sel <= 2 then
        menu.sel = sel + 1

        -- "select"
    elseif inputs.yes:once() then
        -- initialize player 1
        add(Players, Player:new({num = 1, cpu = false}))

        -- if a 1-player game is selected, create a CPU opponent
        local cpu = false
        if menu.sel == 1 then cpu = true end

        -- initialize player 2
        add(Players, Player:new({num = 2, cpu = cpu}))

        -- load the map interstitial
        -- TODO: handle this differently in 2-player mode
        Screens.load("intr")
    end
end

-- draw the title screen
function Screens.title.draw()
    rectfill(0, 0, 127, 127, 12)
    String.centerX("balance of power", 30, 1)

    local menu = MenuScreenTitle
    local y = 50

    for i, choice in ipairs(menu.choices) do
        if i == menu.sel then
            print("* " .. choice, 20, y, 1)
        else
            print("  " .. choice, 20, y, 1)
        end

        y = y + 10
    end
end

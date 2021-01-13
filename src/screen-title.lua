-- update the title screen
function Screens.title.update()
    local menu = MenuScreenTitle
    local sel = menu.sel

    -- up
    if BtnUp:btnp(2) and sel >= 2 then
        menu.sel = sel - 1

        -- down
    elseif BtnDown:btnp(3) and sel <= 2 then
        menu.sel = sel + 1

        -- "select"
    elseif BtnX:btnp(5) then
        -- initialize player 1
        add(Players, Player:new({num = 1, cpu = false}))

        -- if a 1-player game is selected, create a CPU opponent
        local cpu = false
        if menu.sel == 1 then cpu = true end

        -- initialize player 2
        add(Players, Player:new({num = 2, cpu = cpu}))

        -- TODO: remove this explict call
        Map:load(1)
        Screens.load("battle")
    end
end

-- draw the title screen
function Screens.title.draw()
    rectfill(0, 0, 127, 127, 12)
    print("balance of power", 39, 30, 1)

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

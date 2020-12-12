-- update the title screen
function Screens.title.update()
    local menu = MenuScreenTitle
    local sel = menu.sel

    -- up
    if btnp(2) and sel >= 2 then
        menu.sel = sel - 1

        -- down
    elseif btnp(3) and sel <= 2 then
        menu.sel = sel + 1

        -- "select"
    elseif btnp(5) then
        -- if a 1-player game is selected, set a CPU opponent state flag
        if menu.sel == 1 then Game.state.cpu = true end

        -- TODO: load the screen/loop appropriate for the menu selection
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

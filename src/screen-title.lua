-- update the title screen
function game.screens.title.update()
    local sel = game.screens.title.menu.sel

    -- up
    if btnp(2) and sel >= 2 then
        game.screens.title.menu.sel = sel - 1

        -- down
    elseif btnp(3) and sel <= 2 then
        game.screens.title.menu.sel = sel + 1

        -- "select"
    elseif btnp(5) then
        -- TODO: load the screen/loop appropriate for the menu selection
        game.maps.load(1)
        game.screens.load("battle")
    end
end

-- draw the title screen
function game.screens.title.draw()
    rectfill(0, 0, 127, 127, 12)
    print("balance of power", 39, 30, 1)

    local y = 50

    for i, choice in ipairs(game.screens.title.menu.choices) do
        if i == game.screens.title.menu.sel then
            print("* " .. choice, 20, y, 1)
        else
            print("  " .. choice, 20, y, 1)
        end

        y = y + 10
    end
end

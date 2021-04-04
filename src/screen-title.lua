-- update the title screen
function Screens.title.update(state, inputs)
    Menus.Title:update(state, inputs)
end

-- draw the title screen
function Screens.title.draw(state)
    rectfill(0, 0, 127, 127, 12)
    String.centerX("balance of power", 30, 1, state)
    Menus.Title:draw(state)
end

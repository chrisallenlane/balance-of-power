function _init()
    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then menuitem(1, "advance stage", Map.advance) end

    -- implement a "reset map" menu function
    menuitem(2, "reset map", Map.reset)

    -- load the first map
    Map:load(1)

    -- load the title screen
    -- TODO: move to state initialization
    State.screen = Screens.title
end

function _update60()
    Inputs:poll(Player.num)
    State.screen.update(Inputs)
end

function _draw()
    State.screen:draw()
end

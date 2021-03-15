function _init()
    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then menuitem(1, "advance stage", Map.advance) end

    -- implement a "reset map" menu function
    menuitem(2, "reset map", Map.reset)

    -- load the first map
    Map:load(1)

    -- load the title screen
    Screens.load("title")

    -- TODO: initialize two players, one of which may be a CPU depending on
    -- the title screen selection
end

function _update60()
    Inputs:poll(Player.player)
    Game.screen.update(Inputs)
end

function _draw()
    Game.screen:draw()
end

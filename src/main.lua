function _init()
    -- initialize players
    -- NB: P2 will be flagged as a CPU in the title screen if appropriate
    add(Players, Player:new({num = 1, cpu = false}))
    add(Players, Player:new({num = 1, cpu = false}))

    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then menuitem(1, "advance stage", Map.advance) end

    -- implement a "reset map" menu function
    menuitem(2, "reset map", Map.reset)

    -- load the first map
    Map:load(1)

    -- load the title screen
    Screens.load("title")
end

function _update60()
    Inputs:poll(Player.num)
    Game.screen.update(Inputs)
end

function _draw()
    Game.screen:draw()
end

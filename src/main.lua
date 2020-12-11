-- https://www.lua.org/pil/contents.html#P1
-- https://pico-8.fandom.com/wiki/APIReference
function _init()
    -- implement an "advance stage" debug function
    -- TODO: remove this later
    menuitem(1, "advance stage", function()
        if Game.state.map < #Game.maps then
            Game.state.map = Game.state.map + 1
            Game.maps.load(Game.state.map)
        else
            Screens.load("victory")
        end
    end)

    -- implement a "reset map" menu function
    menuitem(2, "reset map", function()
        Game.maps.load(Game.state.map)
    end)

    Screens.load("title")
end

function _update60()
    Game.screen:update()
end

function _draw()
    Game.screen:draw()
end

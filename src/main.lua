-- https://www.lua.org/pil/contents.html#P1
-- https://pico-8.fandom.com/wiki/APIReference
function _init()
    -- implement an "advance stage" debug function
    -- TODO: remove this later
    menuitem(1, "advance stage", function()
        if game.state.map < #game.maps then
            game.state.map = game.state.map + 1
            game.maps.load(game.state.map)
        else
            game.screens.load("victory")
        end
    end)

    -- implement a "reset map" menu function
    menuitem(2, "reset map", function()
        game.maps.load(game.state.map)
    end)

    game.screens.load("title")
end

function _update60()
    game.screen:update()
end

function _draw()
    game.screen:draw()
end

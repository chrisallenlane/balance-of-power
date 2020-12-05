-- https://www.lua.org/pil/contents.html#P1
-- https://pico-8.fandom.com/wiki/APIReference
function _init()
    menuitem(1, "advance stage", function()
        if game.state.map < #game.maps then
            game.state.map = game.state.map + 1
            game.maps.load(game.state.map)
        else
            game.screens.load("victory")
        end
    end)
    game.screens.load("title")
end

function _update()
    game.screen:update()
end

function _draw()
    game.screen:draw()
end

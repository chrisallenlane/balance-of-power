-- https://www.lua.org/pil/contents.html#P1
-- https://pico-8.fandom.com/wiki/APIReference
function _init()
    game.screens.load("title")
end

function _update()
    game.screen.update()
end

function _draw()
    game.screen.draw()
end

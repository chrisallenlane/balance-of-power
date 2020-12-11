function _init()
    -- implement an "advance stage" debug function
    -- TODO: remove this later
    menuitem(1, "advance stage", function()
        if Map.num < #Map.defs then
            Map.num = Map.num + 1
            Map:load(Map.num)
        else
            Screens.load("victory")
        end
    end)

    -- implement a "reset map" menu function
    menuitem(2, "reset map", function()
        Map:load(Map.num)
    end)

    Screens.load("title")
end

function _update60()
    Game.screen:update()
end

function _draw()
    Game.screen:draw()
end

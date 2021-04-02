function _init()
    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then
        menuitem(1, "advance stage", function()
            State.stage:advance(Stages, Screens, State)
        end)
    end

    -- implement a "reset stage" menu function
    menuitem(2, "reset stage", function()
        Stage.load(State.stage.num, Stages, Screens, State)
    end)

    -- build an in-memory table of cell traversal costs
    Cell.costs = Cell.init()
end

function _update60()
    Inputs:poll(State.player.num or 1)
    State.screen.update(State, Inputs)
end

function _draw()
    State.screen.draw(State)
end

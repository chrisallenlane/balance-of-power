function _init()
    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then
        menuitem(1, "advance stage", function()
            State.stage:advance(Stages, Screens, State)
        end)
    end

    -- implement a "reset stage" menu function
    menuitem(2, "reset stage", function()
        Stage.load(State.stage.num, Stages, State)
    end)

    -- load the first stage
    Stage.load(1, Stages, State)
end

function _update60()
    Inputs:poll(State.player.num)
    State.screen.update(State, Inputs)
end

function _draw()
    State.screen.draw(State)
end

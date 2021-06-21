function _init()
    -- set up cartridge persistence
    cartdata("mudbound_dragon_balance_of_power_v_alpha")

    -- implement an "advance stage" debug function
    if DEBUG_CHEAT then
        menuitem(1, "advance stage", function()
            State.stage:advance(Stages, Screens, State)
        end)

        -- clear autosave data
        menuitem(3, "clear autosave", function()
            dset(0, 0)
        end)
    end

    -- implement a "reset stage" menu function
    menuitem(2, "reset stage", function()
        Stage.load(State.stage.num, Stages, Screens, State)
    end)

    -- load autosave data
    State.savedStage = dget(0)
    if State.savedStage ~= 0 then add(Menus.Title.choices, "continue") end

    -- build an in-memory table of cell traversal costs
    Cell.data = Cell.init()

    -- unserialize stage data
    Stages = Stage.unserialize(StageData)
end

function _update60()
    Inputs:poll(State.player.num or 1)
    State.screen.update(State, Inputs)
end

function _draw()
    State.screen.draw(State)
end

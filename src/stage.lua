Stage = {num = 1}

-- load the specified stage
-- TODO: pass in `Stages`
function Stage:load(num, state)
    -- load the specified stage
    -- TODO: remove this?
    self.num = num
    state.stage = Stages[num]()

    -- make it player 1's turn
    state.player = state.players[1]

    -- reset the cursor
    state.player.cursor:clear()

    -- reset the cursor position
    state.player.cursor:warp(state.stage.cursor.x, state.stage.cursor.y)

    -- reset the camera position
    state.camera:warp(state.stage.camera.x, state.stage.camera.y)
end

-- advance to the next stage
-- TODO: remove global `State`
-- TODO: pass in `Stages`
function Stage.advance()
    if Stage.num < #Stages then
        Stage.num = Stage.num + 1
        Stage:load(Stage.num, State)
        State.screen = Screens.intr
    else
        State.screen = Screens.victory
    end
end

-- reset the current stage
-- TODO: implement confirmation menu
-- TODO: remove global `State`
function Stage.reset()
    Stage:load(Stage.num, State)
end

-- return true if the stage has been cleared
function Stage.clear(state)
    -- get the number of units remaining for each player
    local p1, p2 = Units.remain(state.stage.units)

    -- player 1 is victorious
    if p2 == 0 then
        return true, 1

        -- player 2 is victorious
    elseif p1 == 0 then
        return true, 2

        -- the match is ungoing
    else
        return false, nil
    end
end

-- draw the current stage
function Stage.draw(state)
    local m = state.stage
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

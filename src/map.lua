Map = {num = 1}

-- load the specified map
-- TODO: pass in `Maps`
function Map:load(num, state)
    -- load the specified map
    -- TODO: remove this?
    self.num = num
    state.map = Maps[num]()

    -- reset the cursor
    state.cursor:clear()

    -- make it player 1's turn
    -- TODO: do something with this
    Player.num = 1

    -- reset the cursor position
    state.cursor:warp(state.map.cursor.x, state.map.cursor.y)

    -- reset the camera position
    state.camera:warp(state.map.camera.x, state.map.camera.y)
end

-- advance to the next map
-- TODO: remove global `State`
-- TODO: pass in `Maps`
function Map.advance()
    if Map.num < #Maps then
        Map.num = Map.num + 1
        Map:load(Map.num, State)
        State.screen = Screens.intr
    else
        State.screen = Screens.victory
    end
end

-- reset the current map
-- TODO: implement confirmation menu
-- TODO: remove global `State`
function Map.reset()
    Map:load(Map.num, State)
end

-- return true if the map has been cleared
function Map.clear(state)
    -- get the number of units remaining for each player
    local p1, p2 = Units.remain(state.map.units)

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

-- draw the current map
function Map.draw(state)
    local m = state.map
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

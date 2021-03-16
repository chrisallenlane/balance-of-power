-- initialize the map table
Map = {
    -- the number of the current map
    num = 1,

    -- the current map instance
    current = {},

    -- the map definitions
    defs = {},
}

-- load the specified map
function Map:load(num)
    -- load the specified map
    self.num = num
    self.current = self.defs[num]()

    -- reset the cursor
    Cursor:clear()

    -- make it player 1's turn
    Player.num = 1

    -- reset the cursor position
    Cursor:warp(self.current.cursor.x, self.current.cursor.y)

    -- reset the camera position
    Camera:warp(self.current.camera.x, self.current.camera.y)
end

-- advance to the next map
function Map.advance()
    if Map.num < #Map.defs then
        Map.num = Map.num + 1
        Map:load(Map.num)
        State.screen = Screens.intr
    else
        State.screen = Screens.victory
    end
end

-- reset the current map
-- TODO: implement confirmation menu
function Map.reset()
    Map:load(Map.num)
end

-- return true if the map has been cleared
function Map:clear()
    -- get the number of units remaining for each player
    local p1, p2 = Units.remain(self.current.units)

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
function Map:draw()
    local m = self.current
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

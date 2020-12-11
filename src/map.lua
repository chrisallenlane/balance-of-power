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

    -- make it player 1's turn
    Turn.player = 1

    -- reset the cursor position
    Cursor.cell.x, Cursor.cell.y = self.current.cursor.x, self.current.cursor.y

    -- reset the camera position
    Camera.cell.x, Camera.cell.y = self.current.camera.x, self.current.camera.y
    Camera.px.x, Camera.px.y = self.current.camera.x * 8,
                               self.current.camera.y * 8
end

-- draw the current map
function Map:draw()
    local m = self.current
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

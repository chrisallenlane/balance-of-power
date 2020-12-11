-- initialize the map table
Game.maps = {}

-- load the specified map
function Game.maps.load(num)
    -- load the specified map
    Game.state.map = num
    Game.map = Game.maps[num]()

    -- make it player 1's turn
    Game.cursor.turn = 1

    -- reset the cursor position
    Game.cursor.cell.x, Game.cursor.cell.y = Game.map.cursor.x,
                                             Game.map.cursor.y

    -- reset the camera position
    Camera.cell.x, Camera.cell.y = Game.map.camera.x, Game.map.camera.y
    Camera.px.x, Camera.px.y = Game.map.camera.x * 8, Game.map.camera.y * 8
end

-- draw the current map
function Game.maps.draw()
    local m = Game.map
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

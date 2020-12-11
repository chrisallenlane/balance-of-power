-- initialize the map table
game.maps = {}

-- load the specified map
function game.maps.load(num)
    -- load the specified map
    game.state.map = num
    game.map = game.maps[num]()

    -- make it player 1's turn
    game.cursor.turn = 1

    -- reset the cursor position
    game.cursor.cell.x, game.cursor.cell.y = game.map.cursor.x,
                                             game.map.cursor.y

    -- reset the camera position
    game.camera.cell.x, game.camera.cell.y = game.map.camera.x,
                                             game.map.camera.y
    game.camera.px.x, game.camera.px.y = game.map.camera.x * 8,
                                         game.map.camera.y * 8
end

-- draw the current map
function game.maps.draw()
    local m = game.map
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

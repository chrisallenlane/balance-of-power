-- specify map coordinates
game.maps = {
    {
        camera = {x = 0, y = 0},

        cell = {x = 0, y = 0, w = 32, h = 16},

        cursor = {x = 1, y = 1},

        units = {
            p1 = {{21, 8, 8}, {21, 16, 16}, {21, 24, 24}},
            p2 = {{5, 26 * 8, 64}},
        },
    },

    {
        camera = {x = 0, y = 15},

        cell = {x = 32, y = 0, w = 16, h = 32},

        cursor = {x = 1, y = 28},

        units = {
            p1 = {{21, 3 * 8, 28 * 8}, {21, 3 * 8, 29 * 8}, {21, 3 * 8, 30 * 8}},
            p2 = {{5, 8, 8}, {5, 16, 16}, {5, 24, 24}},
        },
    },

    {
        camera = {x = 16, y = 16},

        cell = {x = 48, y = 0, w = 32, h = 32},

        cursor = {x = 28, y = 30},

        units = {p1 = {{21, 8, 8}}, p2 = {{5, 16, 16}}},
    },
}

-- load the specified map
function game.maps.load(num)
    -- load the specified map
    game.state.map = num
    game.map = game.maps[num]

    -- reset the cursor position
    game.cursor.cell.x, game.cursor.cell.y = game.map.cursor.x,
                                             game.map.cursor.y

    -- reset the camera position
    game.camera.cell.x, game.camera.cell.y = game.map.camera.x,
                                             game.map.camera.y
    game.camera.p.x, game.camera.p.y = game.map.camera.x * 8,
                                       game.map.camera.y * 8
end

-- draw the current map
function game.maps.draw()
    local m = game.map
    map(m.cell.x, m.cell.y, 0, 0, m.cell.w, m.cell.h)
end

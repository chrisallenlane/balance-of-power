-- specify map coordinates
game.maps = {
    {
        celx = 0,
        cely = 0,
        sx = 0,
        sy = 0,
        celw = 32,
        celh = 16,
        curx = 1,
        cury = 1,
        camx = 0,
        camy = 0,
    },

    {
        celx = 32,
        cely = 0,
        sx = 0,
        sy = 0,
        celw = 16,
        celh = 32,
        curx = 1,
        cury = 28,
        camx = 0,
        camy = 15,
    },

    {
        celx = 48,
        cely = 0,
        sx = 0,
        sy = 0,
        celw = 32,
        celh = 32,
        curx = 28,
        cury = 30,
        camx = 16,
        camy = 16,
    },
}

-- load the specified map
function game.maps.load(num)
    -- load the specified map
    game.state.map = num
    game.map = game.maps[num]

    -- reset the cursor position
    game.cursor.celx, game.cursor.cely = game.map.curx, game.map.cury

    -- reset the camera position
    game.camera.celx, game.camera.cely = game.map.camx, game.map.camy
    game.camera.px, game.camera.py = game.map.camx * 8, game.map.camy * 8
end

-- draw the current map
function game.maps.draw()
    local m = game.map
    map(m.celx, m.cely, m.sx, m.sy, m.celw, m.celh)
end

-- specify map coordinates
game.maps = {
    {celx = 0, cely = 0, sx = 0, sy = 0, celw = 32, celh = 16},

    {celx = 32, cely = 0, sx = 0, sy = 0, celw = 16, celh = 16},

    {celx = 48, cely = 0, sx = 0, sy = 0, celw = 16, celh = 16},
}

-- load the specified map
function game.maps.load(num)
    game.map = game.maps[num]
end

-- draw the current map
function game.maps.draw()
    local m = game.map
    map(m.celx, m.cely, m.sx, m.sy, m.celw, m.celh)
end

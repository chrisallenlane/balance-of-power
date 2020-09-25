-- specify map coordinates
game.maps = {
    [0] = {celx = 0, cely = 0, sx = 0, sy = 0, celw = 32, celh = 16},

    [1] = {celx = 32, cely = 0, sx = 0, sy = 0, celw = 16, celh = 16},

    [2] = {celx = 48, cely = 0, sx = 0, sy = 0, celw = 16, celh = 16},
}

-- XXX: does this belong here?
game.map = game.maps[0]

-- load the specified map
function game.map.load(num)
    game.map = game.maps[num]
end

-- draw the current map
function game.map.draw()
    map(game.map.celx, game.map.cely, game.map.sx, game.map.sy, game.map.celw,
        game.map.celh)
end

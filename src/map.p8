-- specify map coordinates
game.maps = {
  [0] = {
    celx = 0,
    cely = 0,
    sx = 0,
    sy = 0,
    celw = 32,
    celh = 16,
  },

  [1] = {
    celx = 32,
    cely = 0,
    sx = 0,
    sy = 0,
    celw = 16,
    celh = 16,
  },

  [2] = {
    celx = 48,
    cely = 0,
    sx = 0,
    sy = 0,
    celw = 16,
    celh = 16,
  },
}

game.map = {
  number = 0,
  height = 64*8,
  width  = 128*8,
}

-- load the specified map
function game.map.draw(num)
  map(
    game.maps[num].celx,
    game.maps[num].cely,
    game.maps[num].sx,
    game.maps[num].sy,
    game.maps[num].celw,
    game.maps[num].celh
  )
end

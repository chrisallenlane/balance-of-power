add(game.maps, {
  camera = {x = 0, y = 0},

  cell = {x = 0, y = 0, w = 32, h = 16},

  cursor = {x = 1, y = 1},

  units = {
    [1] = { [1] = Unit:new({spr = 80, team = 1, cell = {x = 1, y = 1}}) },
    [2] = { [2] = Unit:new({spr = 80, team = 1, cell = {x = 2, y = 2}}) },
    [3] = { [3] = Unit:new({spr = 80, team = 1, cell = {x = 3, y = 3}}) },
    [26] = { [8] = Unit:new({spr = 64, team = 2, cell = {x = 26, y = 8}}) },
  },
})

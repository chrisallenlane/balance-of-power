add(game.maps, {
  camera = {x = 0, y = 0},

  cell = {x = 0, y = 0, w = 32, h = 16},

  cursor = {x = 1, y = 1},

  units = {
    p1 = {
      [1] = { [1] = Unit:new({spr = 80, team = 1}) },
      [2] = { [2] = Unit:new({spr = 80, team = 1}) },
      [3] = { [3] = Unit:new({spr = 80, team = 1}) },
    },

    p2 = {
      [26] = { [8] = Unit:new({spr = 64, team = 2}) }
    }
  },
})

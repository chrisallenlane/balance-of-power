add(game.maps, {
  camera = {x = 0, y = 0},

  cell = {x = 0, y = 0, w = 32, h = 16},

  cursor = {x = 1, y = 1},

  units = {
    p1 = {
      Unit:new({spr = 21, cell = {x = 1, y = 1}}),
      Unit:new({spr = 21, cell = {x = 2, y = 2}}),
      Unit:new({spr = 21, cell = {x = 3, y = 3}}),
    },

    p2 = {
      Unit:new({spr = 5, cell = {x = 26, y = 8}}),
    }
  },
})

add(game.maps, {
  camera = {x = 0, y = 0},

  cell = {x = 0, y = 0, w = 32, h = 16},

  cursor = {x = 1, y = 1},

  units = {
    p1 = {
      Unit:new({spr = 21, cell = {x = 8, y = 8}}),
      Unit:new({spr = 21, cell = {x = 16, y = 16}}),
      Unit:new({spr = 21, cell = {x = 24, y = 24}}),
    },

    p2 = {
      Unit:new({spr = 5, cell = {x = 26*8, y = 64}}),
    }
  },
})

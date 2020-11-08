add(game.maps, {
  camera = {x = 0, y = 15},

  cell = {x = 32, y = 0, w = 16, h = 32},

  cursor = {x = 1, y = 28},

  units = {
    p1 = {
      Unit:new({spr = 21, cell = {x = 3*8, y = 28*8}}),
      Unit:new({spr = 21, cell = {x = 3*8, y = 29*8}}),
      Unit:new({spr = 21, cell = {x = 3*8, y = 30*8}}),
    },

    p2 = {
      Unit:new({spr = 5, cell = {x = 8, y = 8}}),
      Unit:new({spr = 5, cell = {x = 8, y = 16}}),
      Unit:new({spr = 5, cell = {x = 8, y = 24}}),
    }
  },
})

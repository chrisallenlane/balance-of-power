add(game.maps, {
  camera = {x = 0, y = 15},

  cell = {x = 32, y = 0, w = 16, h = 32},

  cursor = {x = 1, y = 28},

  units = {
    p1 = {
      [3] = {
        [28] = Unit:new({spr = 21}),
        [29] = Unit:new({spr = 21}),
        [30] = Unit:new({spr = 21}),
      }
    },

    p2 = {
      [1] = {
        [1] = Unit:new({spr = 5}),
        [2] = Unit:new({spr = 5}),
        [3] = Unit:new({spr = 5}),
      }
    },
  },
})

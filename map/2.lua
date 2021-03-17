add(Maps, function ()
  return {
    intr = {
        head = "stage 2",
        body = "lorem ipsum dolor sit amet.",
    },

    camera = {x = 0, y = 16},

    cell = {x = 32, y = 0, w = 16, h = 32},

    cursor = {x = 3, y = 27},

    units = {
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 27}}),
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 28}}),
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 29}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 1}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 2}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 3}}),
    },
  }
end)

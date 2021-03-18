add(Stages, function ()
  return {
    intr = {
        head = "stage 1",
        body = "lorem ipsum dolor sit amet.",
    },

    camera = {x = 0, y = 0},

    cell = {x = 0, y = 0, w = 32, h = 16},

    cursor = {x = 1, y = 1},

    units = {
      Unit:new({spr = 80, player = 1, cell = {x = 1, y = 1}}),
      Unit:new({spr = 80, player = 1, cell = {x = 2, y = 2}}),
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 3}}),
      Unit:new({spr = 64, player = 2, cell = {x = 28, y = 7}}),
    },
  }
end)

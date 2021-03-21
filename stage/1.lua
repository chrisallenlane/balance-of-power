add(Stages, function ()
  return {
    num = 1,

    intr = {
        head = "stage 1",
        body = "lorem ipsum dolor sit amet.",
    },

    camera = {x = 0, y = 0},

    cell = {x = 0, y = 0, w = 32, h = 16},

    units = {
      Unit:new({player = 1, cell = {x = 1, y = 1}}),
      Unit:new({player = 1, cell = {x = 2, y = 2}}),
      Unit:new({player = 1, cell = {x = 3, y = 3}}),
      Unit:new({player = 2, cell = {x = 28, y = 7}}),
    },
  }
end)

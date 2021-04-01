add(Stages, function ()
  return {
    num = 3,

    intr = {
        head = "stage 3",
        body = "lorem ipsum dolor sit amet.",
    },

    -- palette swaps
    swap = {
        {12, 1},
    },

    camera = {x = 16, y = 16},

    cell = {x = 48, y = 0, w = 32, h = 32},

    units = {
      Unit:new({player = 1, cell = {x = 28, y = 29}}),
      Unit:new({player = 2, cell = {x = 9, y = 5}}),
    },
  }
end)
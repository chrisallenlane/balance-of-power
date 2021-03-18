add(Stages, function ()
  return {
    intr = {
        head = "stage 3",
        body = "lorem ipsum dolor sit amet.",
    },

    camera = {x = 16, y = 16},

    cell = {x = 48, y = 0, w = 32, h = 32},

    cursor = {x = 28, y = 29},

    units = {
      Unit:new({spr = 80, player = 1, cell = {x = 28, y = 29}}),
      Unit:new({spr = 64, player = 2, cell = {x = 9, y = 5}}),
    },
  }
end)

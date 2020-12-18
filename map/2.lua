add(Map.defs, function ()
  return {
    camera = {x = 0, y = 15},

    cell = {x = 32, y = 0, w = 16, h = 32},

    cursor = {x = 3, y = 28},

    units = {
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 28}, stat = {spd = 3}}),
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 29}, stat = {spd = 3}}),
      Unit:new({spr = 80, player = 1, cell = {x = 3, y = 30}, stat = {spd = 3}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 1}, stat = {spd = 3}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 2}, stat = {spd = 3}}),
      Unit:new({spr = 64, player = 2, cell = {x = 1, y = 3}, stat = {spd = 3}}),
    },
  }
end)

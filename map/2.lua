add(Map.defs, function ()
  return {
    camera = {x = 0, y = 15},

    cell = {x = 32, y = 0, w = 16, h = 32},

    cursor = {x = 1, y = 28},

    units = {
      Unit:new({spr = 80, team = 1, cell = {x = 3, y = 28}}),
      Unit:new({spr = 80, team = 1, cell = {x = 3, y = 29}}),
      Unit:new({spr = 80, team = 1, cell = {x = 3, y = 30}}),
      Unit:new({spr = 64, team = 2, cell = {x = 1, y = 1}}),
      Unit:new({spr = 64, team = 2, cell = {x = 1, y = 2}}),
      Unit:new({spr = 64, team = 2, cell = {x = 1, y = 3}}),
    },
  }
end)

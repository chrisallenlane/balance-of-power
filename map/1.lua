
add(Game.maps, function ()
  return {
    camera = {x = 0, y = 0},

    cell = {x = 0, y = 0, w = 32, h = 16},

    cursor = {x = 1, y = 1},

    units = {
      Unit:new({spr = 80, team = 1, cell = {x = 1, y = 1}}),
      Unit:new({spr = 80, team = 1, cell = {x = 2, y = 2}}),
      Unit:new({spr = 80, team = 1, cell = {x = 3, y = 3}}),
      Unit:new({spr = 64, team = 2, cell = {x = 10, y = 7}}),
    },
  }
end)

function debug(game)

  -- compose debugging messages
  local msgs = {
    [0] = "cur:  " ..  game.cursor.x    .. ", " .. game.cursor.y,
    [1] = "cam:  " .. game.camera.x     .. ", " .. game.camera.y,
    -- TODO: ceil should probably be calculated elsewhere, rather than here
    [2] = "cell: " .. (game.cursor.x/8) .. ", " .. (game.cursor.y/8),
    [3] = "tile: " .. mget(game.cursor.x/8, game.cursor.y/8),
    [4] = "spr:  ?",
    [5] = "mem:  " .. stat(0) .. " kb",
    [6] = "cpu:  " .. stat(1),
  }

  -- iterate over and print each debug message
  for i,msg in pairs(msgs) do
    print(msg, 4+game.camera.x, (4+8*i)+game.camera.y, 7)
  end
end

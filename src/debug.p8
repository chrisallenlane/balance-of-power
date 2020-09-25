function debug(game)

    -- compose debugging messages
    local msgs = {
        [0] = "cur:  " .. game.cursor.celx .. ", " .. game.cursor.cely,
        [1] = "cam:  " .. game.camera.celx .. ", " .. game.camera.cely,
        [2] = "tile: " .. game.cursor.tile,
        [3] = "mspr: " .. mget(game.cursor.celx, game.cursor.cely),
        [4] = "spr:  ?",
        [5] = "mem:  " .. stat(0) .. " kb",
        [6] = "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + game.camera.px, (4 + 8 * i) + game.camera.py, 7)
    end
end

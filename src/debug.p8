debug = {}
function debug.vars(game)

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

-- Debugging key chord: if left, right, and `key` are held down, return true
function debug.chord(key)
    if btn(0) and btn(1) and btnp(key) then return true end
    return false
end

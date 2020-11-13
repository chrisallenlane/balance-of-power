debug = {}
function debug.vars(game)

    -- compose "selection" information
    local sel
    if game.cursor.sel.x and game.cursor.sel.y then
        sel = game.cursor.sel.x .. ", " .. game.cursor.sel.y
    else
        sel = "na"
    end

    -- compose debugging messages
    local msgs = {
        "cur:  " .. game.cursor.cell.x .. ", " .. game.cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. game.camera.cell.x .. ", " .. game.camera.cell.y,
        "tile: " .. game.cursor.tile,
        "mspr: " .. mget(game.cursor.cell.x, game.cursor.cell.y),
        "spr:  ?",
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + game.camera.p.x, (4 + 8 * i) + game.camera.p.y, 7)
    end
end

-- Debugging key chord: if left, right, and `key` are held down, return true
function debug.chord(key)
    if btn(0) and btn(1) and btnp(key) then return true end
    return false
end

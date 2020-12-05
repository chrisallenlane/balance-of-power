debug = {}
function debug.vars(game)

    -- compose "selection" information
    local sel = "na"
    if game.cursor.sel then
        sel = game.cursor.sel.cell.x .. ", " .. game.cursor.sel.cell.y
    end

    -- indicate whether the tile is passable
    local pass = "n"
    if game.cursor.cell.pass then pass = "y" end

    -- indicate whether playing a human or CPU opponent
    -- local p2 = "human"
    -- if game.state.cpu then p2 = "cpu" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. game.cursor.turn,
        "cur:  " .. game.cursor.cell.x .. ", " .. game.cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. game.camera.cell.x .. ", " .. game.camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
        -- "p2:   " .. p2,
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + game.camera.px.x, (4 + 8 * i) + game.camera.px.y, 7)
    end
end

-- Debugging key chord: if left, right, and `key` are held down, return true
function debug.chord(key)
    if btn(0) and btn(1) and btnp(key) then return true end
    return false
end

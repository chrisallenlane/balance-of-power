debug = {}
function debug.vars(game)
    -- compose "selection" information
    local sel = "na"
    if Cursor.sel then sel = Cursor.sel.cell.x .. ", " .. Cursor.sel.cell.y end

    -- indicate whether the tile is passable
    local pass = "n"
    if Cursor.cell.pass then pass = "y" end

    -- indicate whether playing a human or CPU opponent
    -- local p2 = "human"
    -- if game.state.cpu then p2 = "cpu" end

    local lock = "n"
    if game.lock.camera then lock = "y" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. Cursor.turn,
        "cur:  " .. Cursor.cell.x .. ", " .. Cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. Camera.cell.x .. ", " .. Camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
        "lock: " .. lock,
        "del:  " .. game.delay.unit .. ", " .. game.delay.cpu,
        -- "p2:   " .. p2,
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + Camera.px.x, (4 + 8 * i) + Camera.px.y, 7)
    end
end

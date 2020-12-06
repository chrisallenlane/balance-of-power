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

    local lock = "n"
    if game.lock.cursor then lock = "y" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. game.cursor.turn,
        "cur:  " .. game.cursor.cell.x .. ", " .. game.cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. game.camera.cell.x .. ", " .. game.camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
        "lock: " .. lock,
        -- "p2:   " .. p2,
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + game.camera.px.x, (4 + 8 * i) + game.camera.px.y, 7)
    end
end

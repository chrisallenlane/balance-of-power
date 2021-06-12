Debug = {}
function Debug.vars(state)
    local camera, player = state.camera, state.player
    local cur = player.cursor

    -- compose "selection" information
    local sel = "na"
    if cur.sel then sel = cur.sel.cell.x .. ", " .. cur.sel.cell.y end

    -- indicate whether the tile is passable
    local pass = "n"
    if Cell.pass(cur.cell.x, cur.cell.y, state.stage, player.num) then
        pass = "y"
    end

    -- compose debugging messages
    local msgs = {
        "turn: " .. player.num,
        "cur:  " .. cur.cell.x .. ", " .. cur.cell.y,
        "sel:  " .. sel,
        "cam:  " .. camera.cell.x .. ", " .. camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + camera.pxx, (4 + 8 * i) + camera.pxy, 7)
    end
end

function Debug.log(vals)
    local line = ""
    for _, v in ipairs(vals) do line = line .. v .. ", " end
    printh(line)
end

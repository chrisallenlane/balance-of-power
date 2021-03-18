Debug = {}
function Debug.vars(state)
    -- compose "selection" information
    local sel = "na"
    if state.player.cursor.sel then
        sel = state.player.cursor.sel.cell.x .. ", " ..
                  state.player.cursor.sel.cell.y
    end

    -- indicate whether the tile is passable
    local pass = "n"
    if Cell.pass(state.player.cursor.cell.x, state.player.cursor.cell.y,
                 state.stage, state.player.num) then pass = "y" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. state.player.num,
        "cur:  " .. state.player.cursor.cell.x .. ", " ..
            state.player.cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. state.camera.cell.x .. ", " .. state.camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + state.camera.px.x, (4 + 8 * i) + state.camera.px.y, 7)
    end
end

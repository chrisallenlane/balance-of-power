Debug = {}
function Debug.vars()
    -- compose "selection" information
    local sel = "na"
    if State.cursor.sel then
        sel = State.cursor.sel.cell.x .. ", " .. State.cursor.sel.cell.y
    end

    -- indicate whether the tile is passable
    local pass = "n"
    if Cell.pass(State.cursor.cell.x, State.cursor.cell.y, Map.current,
                 Player.num) then pass = "y" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. Player.num,
        "cur:  " .. State.cursor.cell.x .. ", " .. State.cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. State.camera.cell.x .. ", " .. State.camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + State.camera.px.x, (4 + 8 * i) + State.camera.px.y, 7)
    end
end

Debug = {}
function Debug.vars()
    -- compose "selection" information
    local sel = "na"
    if Cursor.sel then sel = Cursor.sel.cell.x .. ", " .. Cursor.sel.cell.y end

    -- indicate whether the tile is passable
    local pass = "n"
    if Cursor.cell.pass then pass = "y" end

    -- compose debugging messages
    local msgs = {
        "turn: " .. Turn.player,
        "cur:  " .. Cursor.cell.x .. ", " .. Cursor.cell.y,
        "sel:  " .. sel,
        "cam:  " .. Camera.cell.x .. ", " .. Camera.cell.y,
        "pass: " .. pass,
        "mem:  " .. stat(0) .. " kb",
        "cpu:  " .. stat(1),
    }

    -- iterate over and print each debug message
    for i, msg in pairs(msgs) do
        print(msg, 4 + Camera.px.x, (4 + 8 * i) + Camera.px.y, 7)
    end
end

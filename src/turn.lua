Turn = {}

-- change the player turn
function Turn.turn_end()
    -- record the current player's cursor position
    Cursor.last[Cursor.turn] = {x = Cursor.cell.x, y = Cursor.cell.y}

    -- end the turn
    if Cursor.turn == 1 then
        Cursor.turn = 2
    else
        Cursor.turn = 1
    end

    -- load the next player's cursor
    if Cursor.last[Cursor.turn].x == nil or Cursor.last[Cursor.turn].y == nil then
        local unit = Unit.first(Cursor.turn, Game.map.units)
        Cursor.cell.x = unit.cell.x
        Cursor.cell.y = unit.cell.y
    else
        Cursor.cell.x = Cursor.last[Cursor.turn].x
        Cursor.cell.y = Cursor.last[Cursor.turn].y
    end

    -- center the screen on the specified coordinates
    Camera:focus(Cursor.cell.x, Cursor.cell.y, Game.map.cell.w, Game.map.cell.h)
end

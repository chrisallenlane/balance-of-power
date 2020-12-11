Turn = {player = 1}

-- change the player turn
function Turn:turn_end()
    -- record the current player's cursor position
    Cursor.last[self.player] = {x = Cursor.cell.x, y = Cursor.cell.y}

    -- end the turn
    if self.player == 1 then
        self.player = 2
    else
        self.player = 1
    end

    -- load the next player's cursor
    if Cursor.last[self.player].x == nil or Cursor.last[self.player].y == nil then
        local unit = Unit.first(self.player, Game.map.units)
        Cursor.cell.x = unit.cell.x
        Cursor.cell.y = unit.cell.y
    else
        Cursor.cell.x = Cursor.last[self.player].x
        Cursor.cell.y = Cursor.last[self.player].y
    end

    -- center the screen on the specified coordinates
    Camera:focus(Cursor.cell.x, Cursor.cell.y, Game.map.cell.w, Game.map.cell.h)
end

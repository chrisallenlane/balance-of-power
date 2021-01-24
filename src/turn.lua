Turn = {player = 1}

-- TODO: move this into player?
-- change the player turn
function Turn:turn_end()
    -- unselect the unit
    Cursor.sel = nil

    -- hide radii
    Radius:clear()

    -- record the current player's cursor position
    Cursor.last[self.player] = {x = Cursor.cell.x, y = Cursor.cell.y}

    -- end the turn
    if self.player == 1 then
        self.player = 2
    else
        self.player = 1
    end

    -- refresh all units
    Units.refresh(Map.current.units)

    -- TODO: refactor into Cursor save/load or something?
    -- load the next player's cursor
    if Cursor.last[self.player].x == nil or Cursor.last[self.player].y == nil then
        local unit = Unit.first(self.player, Map.current.units)
        Cursor.cell.x = unit.cell.x
        Cursor.cell.y = unit.cell.y
    else
        Cursor.cell.x = Cursor.last[self.player].x
        Cursor.cell.y = Cursor.last[self.player].y
    end

    -- center the screen on the specified coordinates
    Camera:focus(Cursor.cell.x, Cursor.cell.y, Map.current.cell.w,
                 Map.current.cell.h)
end

-- return true if the current player is a human
function Turn:human(players)
    return not players[self.player].cpu
end

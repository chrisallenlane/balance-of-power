Cell = {}

-- return true if the map tile is passable
function Cell.passable(x, y, map)
    -- return false if the map tile at the specified coordinates is flagged as
    -- impassible
    if fget(mget(map.cell.x + x, map.cell.y + y), 0) then return false end

    -- return false if a unit is at the specified coordinates
    -- TODO: pass as param
    if Unit.at(x, y, Game.map.units) then return false end
    return true
end

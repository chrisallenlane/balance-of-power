-- Unit prototype
Unit = {}

-- Unit constructor
function Unit:new(u)
    u = u or {}
    setmetatable(u, self)
    self.__index = self

    -- total available power
    u.pwr = u.pwr or 10

    -- player-facing unit stats
    u.stat = u.stat or {atk = 5, rng = 2, mov = 3}

    -- compute the pixel position from the cell position
    u.px = {x = u.cell.x * 8, y = u.cell.y * 8}

    -- track actions taken
    u.act = {atk = false, bal = false, mov = false}

    return u
end

-- At returns the unit at the specified coordinates, or false if none is there
function Unit.at(x, y, units)
    -- XXX: this runs in linear time
    for idx, unit in pairs(units) do
        if unit.cell.x == x and unit.cell.y == y then return unit, idx end
    end

    return false, nil
end

-- Returns the first unit on `player`'s team team
function Unit.first(player, units)
    -- XXX: this runs in linear time
    for _, unit in pairs(units) do
        if unit.player == player then return unit end
    end

    -- NB: we realistically should never end up here
    -- TODO: throw exception if we somehow do
    return false
end

-- Move moves a unit
function Unit:move(to_x, to_y)
    self.cell.x = to_x
    self.cell.y = to_y
    self.act.mov = true
end

-- Attack attacks a unit
function Unit:attack(target, idx)
    -- TODO: this is a stub
    target.die(idx, Map.current.units)
    self.act.atk = true
end

-- Die kills a unit
function Unit.die(idx, units)
    deli(units, idx)
end

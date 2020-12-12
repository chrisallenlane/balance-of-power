-- Unit prototype
Unit = {
    -- sprite id
    spr = 0,

    -- hit points
    hp = 0,

    -- attack
    atk = 0,

    -- def
    def = 0,

    -- speed
    spd = 0,

    -- cell position
    cell = {x = 0, y = 0},

    -- pixel position
    px = {x = 0, y = 0},

    -- team
    team = 1,

    -- is the unit selected?
    sel = false,
}

-- Unit constructor
function Unit:new(u)
    u = u or {}
    setmetatable(u, self)
    self.__index = self

    -- compute the pixel position from the cell position
    u.px = {x = u.cell.x * 8, y = u.cell.y * 8}

    return u
end

-- At returns the unit at the specified coordinates, or false if none is there
function Unit.at(x, y, units)
    -- XXX: this runs in linear time
    for _, unit in pairs(units) do
        if unit.cell.x == x and unit.cell.y == y then return unit end
    end

    return false
end

-- Returns the first unit on the specified team
function Unit.first(team, units)
    -- XXX: this runs in linear time
    for _, unit in pairs(units) do if unit.team == team then return unit end end

    -- NB: we realistically should never end up here
    -- TODO: throw exception if we somehow do
    return false
end

-- Move moves a unit
function Unit:move(to_x, to_y)
    self.cell.x = to_x
    self.cell.y = to_y
end

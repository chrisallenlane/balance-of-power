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
    return units[x] and units[x][y]
end

-- Move moves a unit
function Unit.move(from_x, from_y, to_x, to_y, units)
    -- vivify the map table if it does not exist
    if not units[to_x] then units[to_x] = {} end

    -- move the selected unit to the current cursor position
    units[to_x][to_y] = units[from_x][from_y]

    -- remove the prior reference to the unit
    units[from_x][from_y] = nil

    return units
end

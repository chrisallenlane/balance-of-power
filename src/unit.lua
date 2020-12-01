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
    u.px = {
      x = u.cell.x*8,
      y = u.cell.y*8,
    }

    return u
end

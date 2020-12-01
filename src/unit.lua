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
    return u
end

-- Move the unit to the designated cell
--function Unit:move(x, y)

--end

--function Unit:sel()

--end

--function Unit:unsel()

--end

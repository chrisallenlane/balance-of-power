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

    -- position
    cell = {x = 0, y = 0},
}

-- Unit constructor
function Unit:new(u)
    u = u or {}
    setmetatable(u, self)
    self.__index = self
    return u
end

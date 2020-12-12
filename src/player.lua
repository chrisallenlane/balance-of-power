Player = {
    -- player 1 or 2
    num = 1,

    -- is the player a CPU?
    cpu = false,
}

Players = {}

-- define the constructor
function Player:new(p)
    p = p or {}
    setmetatable(p, self)
    self.__index = self
    return p
end

Player, Players = {}, {}

-- define the constructor
function Player:new(p)
    setmetatable(p, self)
    self.__index = self
    return p
end

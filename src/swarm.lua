Swarm = {}

-- initialize a swarm
function Swarm:new(x, y)
    local s = {
        pxx = x,
        pxy = y,
        deg = 0,
        ships = {
            {pxx = 0, pxy = 0},
            {pxx = 0, pxy = 0},
            {pxx = 0, pxy = 0},
            {pxx = 0, pxy = 0},
            {pxx = 0, pxy = 0},
        },
    }

    setmetatable(s, self)
    self.__index = self

    return s
end

-- update the position of each ship in the swarm
function Swarm:update(x, y)
    -- move the swarm with the unit
    self.pxx, self.pxy = x, y
    self.deg = self.deg + 0.001
    self.deg = self.deg > 1 and 0 or self.deg

    -- rotate each ship
    for i, ship in pairs(self.ships) do
        local offset = (1 / #self.ships) * i
        -- NB: the +3/+4 center the ships in the cell
        ship.pxx = self.pxx + 4 + 4 * cos(self.deg + offset)
        ship.pxy = self.pxy + 3 + 4 * sin(self.deg + offset)
    end
end

-- draw the warm
function Swarm:draw()
    for _, ship in pairs(self.ships) do spr(0, ship.pxx, ship.pxy) end
end

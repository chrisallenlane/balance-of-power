Swarm = {}

-- initialize a swarm
function Swarm:new(x, y)
    local s = {
        pxx = x,
        pxy = y,
        ships = {
            {pxx = 0, pxy = 0, deg = 0},
            {pxx = 0, pxy = 0, deg = .2},
            {pxx = 0, pxy = 0, deg = .4},
            {pxx = 0, pxy = 0, deg = .6},
            {pxx = 0, pxy = 0, deg = .8},
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

    -- rotate each ship
    for _, ship in pairs(self.ships) do
        ship.deg = ship.deg + 0.001
        ship.deg = ship.deg > 1 and 0 or ship.deg
        ship.pxx = self.pxx + 4 + 4 * cos(ship.deg)
        ship.pxy = self.pxy + 3 + 4 * sin(ship.deg)
    end
end

-- draw the warm
function Swarm:draw()
    for _, ship in pairs(self.ships) do spr(0, ship.pxx, ship.pxy) end
end

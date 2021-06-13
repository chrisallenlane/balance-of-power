Swarm = {}

-- initialize a swarm
function Swarm:new(x, y)
    local s = {
        x = x,
        y = y,
        ships = {
            {x = 0, y = 0, deg = 0},
            {x = 0, y = 0, deg = .2},
            {x = 0, y = 0, deg = .4},
            {x = 0, y = 0, deg = .6},
            {x = 0, y = 0, deg = .8},
        },
    }

    setmetatable(s, self)
    self.__index = self

    return s
end

-- update the position of each ship in the swarm
function Swarm:update(x, y)
    -- move the swarm with the unit
    self.x, self.y = x, y

    -- rotate each ship
    for _, ship in pairs(self.ships) do
        ship.deg = ship.deg + 0.001
        ship.deg = ship.deg > 1 and 0 or ship.deg
        ship.x = self.x + 4 * cos(ship.deg)
        ship.y = self.y + 4 * sin(ship.deg)
    end
end

-- draw the warm
function Swarm:draw()
    for _, ship in pairs(self.ships) do spr(0, ship.x + 4, ship.y + 3) end
end

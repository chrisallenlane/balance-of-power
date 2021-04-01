Radius = {}

function Radius:new()
    local r = {
        center = {x = nil, y = nil},
        cells = {atk = {}, dng = {}, mov = {}},
        cache = {atk = {}, dng = {}, mov = {}},
        vis = false,
    }

    setmetatable(r, self)
    self.__index = self

    return r
end

-- draw a radius at the specified coordinates
function Radius:update(unit, stage, turn)
    -- clear the prior radius
    self:clear()

    -- annotate the center of the radii
    self.center.x = unit.cell.x
    self.center.y = unit.cell.y

    -- NB: we're computing the movement and attack radii separately. That's
    -- not computationally optimial, but much simpler to understand.
    if not unit:moved() then
        self:move(self.center.x, self.center.y, unit.stat.mov, stage, turn)
    end
    -- if the unit has range but no attack, don't render an attack radius
    if not unit:attacked() and unit.stat.atk > 0 then
        -- don't "pay for" the cell where the unit is placed
        self:append('mov', unit.cell.x, unit.cell.y)
        self:dng(self.center.x, self.center.y, unit.stat.rng, stage)
        self:atk(self.center.x, self.center.y, unit.stat.rng, stage)
    end

    -- annotate that the radius is visible
    self.vis = true
end

-- Compute a movement radius centered on `x`, `y`
function Radius:move(x, y, mvmt, stage, turn)
    -- short circuit if the unit has no `mov` points
    if mvmt == 0 then return end

    -- if we've visited this cell before (with `mvmt` movement points
    -- remaining), exit early
    if self:cached('mov', x, y, mvmt) then return end

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Cell.neighbors(x, y, stage)) do
        -- determine the cost to traverse the tile
        local cost = Cell.cost(cell.x, cell.y, stage)
        if mvmt >= cost and Cell.pass(cell.x, cell.y, stage, turn) then
            self:append('mov', cell.x, cell.y)
            self:move(cell.x, cell.y, mvmt - cost, stage, turn)
        end
    end
end

-- Compute an attack radius centered on `x`, `y`
function Radius:atk(x, y, rng, stage)
    -- exit early if we've visited this cell before (with `rng` range points remaining)
    if self:cached('atk', x, y, rng) then return end

    -- pay the range cost
    rng = rng - 1

    -- exit early if we have exhausted our attack radius
    if rng < 0 then return end

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Cell.neighbors(x, y, stage)) do
        self:append('atk', cell.x, cell.y)
        self:atk(cell.x, cell.y, rng, stage)
    end
end

-- Compute a danger radius centered on `x`, `y`
function Radius:dng(x, y, rng, stage)
    -- exit early if we've visited this cell before (with `rng` range points remaining)
    if self:cached('dng', x, y, rng) then return end

    -- cells within the movement radius are implicitly within the attack
    -- radius, so we get those "for free".
    if not self:contains('mov', x, y) then rng = rng - 1 end

    -- exit early if we have exhausted our attack radius
    if rng == 0 then return end

    -- iteratively search this cell's neighbors
    for _, cell in pairs(Cell.neighbors(x, y, stage)) do
        self:append('dng', cell.x, cell.y)
        self:dng(cell.x, cell.y, rng, stage)
    end
end

-- return true if we have already visited a cell with `m` movement remaining
function Radius:cached(key, x, y, m)
    -- return true if we've been here before
    if self.cache[key][x] and self.cache[key][x][y] and self.cache[key][x][y][m] then
        return true
    end

    -- otherwise, note that we've *now* been here, and return false
    if not self.cache[key][x] then self.cache[key][x] = {} end
    if not self.cache[key][x][y] then self.cache[key][x][y] = {} end
    if not self.cache[key][x][y][m] then self.cache[key][x][y][m] = true end
    return false
end

-- append a cell to the radius
function Radius:append(key, x, y)
    if not self.cells[key][x] then self.cells[key][x] = {} end
    self.cells[key][x][y] = true
end

-- remove a cell from the radius
function Radius:remove(key, x, y)
    if self.cells[key] and self.cells[key][x] and self.cells[key][x][y] then
        self.cells[key][x][y] = nil
    end
end

-- return true if x,y is among the cells within the radius
function Radius:contains(key, x, y)
    return self.cells[key][x] and self.cells[key][x][y]
end

-- reset the radius coordinates
function Radius:clear()
    self.cache = {atk = {}, dng = {}, mov = {}}
    self.cells = {atk = {}, dng = {}, mov = {}}
    self.vis = false
end

-- KLUDGE
function Radius.clearAll(units)
    for _, unit in pairs(units) do unit.radius.vis = false end
end

-- draw the radius to the stage
function Radius:draw(friend)
    if not self.vis then return end

    -- choose the sprite to render
    local sprite = 2
    if not friend then sprite = 3 end

    -- don't draw an indicator at the center of the radii
    self:remove('atk', self.center.x, self.center.y)
    self:remove('dng', self.center.x, self.center.y)
    self:remove('mov', self.center.x, self.center.y)

    -- draw the movement radius
    for x, cell in pairs(self.cells.mov) do
        for y, _ in pairs(cell) do spr(sprite, x * 8, y * 8) end
    end

    -- draw the danger radius
    for x, cell in pairs(self.cells.dng) do
        if friend then
            pal(10, 8)
        else
            pal(10, 14)
        end
        for y, _ in pairs(cell) do
            -- NB: making this check and only drawing the necessary cells is
            -- slightly faster than drawing the movement radius on top of the
            -- attack radius
            if not self:contains('mov', x, y) and not self:contains('atk', x, y) then
                spr(6, x * 8, y * 8)
            end
        end
        pal()
    end

    -- draw the attack radius
    for x, cell in pairs(self.cells.atk) do
        pal(1, 8)
        for y, _ in pairs(cell) do
            if not self:contains('mov', x, y) then
                spr(sprite, x * 8, y * 8)
            end
        end
        pal()
    end
end

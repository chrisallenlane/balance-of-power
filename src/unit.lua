-- Unit prototype
Unit = {}

-- Unit constructor
function Unit:new(u)
    u = u or {}
    setmetatable(u, self)
    self.__index = self

    -- total available power
    u.pwr = u.pwr or 10

    -- player-facing unit stats
    u.stat = u.stat or {atk = 5, rng = 2, mov = 3}

    -- compute the pixel position from the cell position
    u.px = {x = u.cell.x * 8, y = u.cell.y * 8}

    -- initialize `from` cells
    u.from = {x = nil, y = nil}

    -- track actions taken
    u.act = u.act or {atk = false, mov = false}

    -- is the unit active (ie, not exhausted)
    u.active = true

    -- cache the radii
    u.radius = Radius:new()

    return u
end

-- Returns a clone (deep copy) of a unit
function Unit.clone(u)
    -- create a deep copy of `u`'s properties
    local clone = {
        spr = u.spr,
        player = u.player,
        cell = {x = u.cell.x, y = u.cell.y},
        from = {x = u.from.x, y = u.from.y},
        pwr = u.pwr,
        stat = {atk = u.stat.atk, mov = u.stat.mov, rng = u.stat.rng},
        px = {x = u.px.x, y = u.px.y},
        act = {atk = u.act.atk, mov = u.act.mov},
        active = u.active,
        -- TODO XXX: this is a shallow copy - though it seems to work?
        radius = u.radius,
    }

    -- initialize and return a cloned unit
    return Unit:new(clone)
end

-- Move moves a unit
function Unit:move(to_x, to_y)
    self.from = {x = self.cell.x, y = self.cell.y}
    self.cell.x, self.cell.y, self.act.mov = to_x, to_y, true
end

-- Reverses the prior move
function Unit:unmove(state)
    -- move the unit to its `from` position
    self.cell.x, self.cell.y = self.from.x, self.from.y

    -- clear the `from` position
    self.from = {x = nil, y = nil}

    -- place the cursor back atop the unit
    state.player.cursor.cell.x, state.player.cursor.cell.y = self.cell.x,
                                                             self.cell.y
    -- refresh all units on this unit's team
    for _, unit in pairs(state.stage.units) do
        if unit.player == self.player then
            unit.active, unit.act.atk, unit.act.mov = true, false, false
        end
    end
end

-- Attack attacks a unit
function Unit:attack(target, stat, atk, def, overflow, state)
    -- record that the unit has attacked
    self.act.atk = true

    -- set the attacking player's cursor position atop the attacking unit
    -- (This is a QOL feature for the next turn.)
    state.player.cursor.cell = {x = self.cell.x, y = self.cell.y}

    -- compute the damage inflicted, ensuring that it is at least `1`
    local dmg = atk - def
    if dmg <= 0 then dmg = 1 end

    -- damage the target
    -- if this is overflow damage, don't substract from pwr
    if not overflow then
        target.pwr = target.pwr - dmg

        -- kill the unit if its pwr reaches 0
        if target.pwr <= 0 then return true end
    end

    -- damage the targeted system
    target.stat[stat] = target.stat[stat] - dmg

    -- overflow damage if necessary
    if target.stat[stat] < 0 then
        -- compute the overflow damage
        dmg = target.stat[stat] * -1

        -- zero the disabled system
        target.stat[stat] = 0

        -- recursively damage the next system
        -- NB: zero out `def` so we don't double-count it
        self:attack(target, target:functional(), dmg, 0, true, state)
    end

    return false
end

-- Return true if the unit has moved
function Unit:moved()
    return self.act.mov
end

-- Return true if the unit has attacked
function Unit:attacked()
    return self.act.atk
end

-- Return true if the unit has taken any action
function Unit:acted()
    return self.act.mov or self.act.atk
end

-- Activate the unit
function Unit:activate()
    self.active = true
end

-- Deactivate the unit
function Unit:deactivate()
    self.active = false
end

-- Return the first functional unit system
function Unit:functional()
    for _, stat in ipairs({'atk', 'rng', 'mov'}) do
        if self.stat[stat] >= 1 then return stat end
    end
end

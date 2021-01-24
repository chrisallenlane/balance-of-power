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
    u.px = u.px or {x = u.cell.x * 8, y = u.cell.y * 8}

    -- track actions taken
    u.act = u.act or {atk = false, mov = false}

    -- is the unit active (ie, not exhausted)
    u.active = true

    return u
end

-- Returns a clone (deep copy) of a unit
function Unit.clone(u)
    -- create a deep copy of `u`'s properties
    local clone = {
        spr = u.spr,
        player = u.player,
        cell = {x = u.cell.x, y = u.cell.y},
        pwr = u.pwr,
        stat = {atk = u.stat.atk, mov = u.stat.mov, rng = u.stat.rng},
        px = {x = u.px.x, y = u.px.y},
        act = {atk = u.act.atk, mov = u.act.mov},
        active = u.active,
    }

    -- initialize and return a cloned unit
    return Unit:new(clone)
end

-- At returns the unit at the specified coordinates, or false if none is there
function Unit.at(x, y, units)
    -- XXX: this runs in linear time
    for idx, unit in pairs(units) do
        if unit.cell.x == x and unit.cell.y == y then return unit, idx end
    end

    return false, nil
end

-- Returns the first unit on `player`'s team team
function Unit.first(player, units)
    -- XXX: this runs in linear time
    for _, unit in pairs(units) do
        if unit.player == player then return unit end
    end

    -- NB: we realistically should never end up here
    -- TODO: throw exception if we somehow do
    return false
end

-- Move moves a unit
function Unit:move(to_x, to_y)
    self.cell.x = to_x
    self.cell.y = to_y
    self.act.mov = true
end

-- Attack attacks a unit
function Unit:attack(target, stat, atk, idx, overflow)
    -- record that the unit has attacked
    self.act.atk = true

    -- damage the target
    -- if this is overflow damage, don't substract from pwr
    if not overflow then
        target.pwr = target.pwr - atk

        -- kill the unit if its pwr reaches 0
        if target.pwr <= 0 then
            target.die(idx, Map.current.units)
            return
        end
    end

    -- damage the targeted system
    target.stat[stat] = target.stat[stat] - atk

    -- overflow damage if necessary
    if target.stat[stat] < 0 then
        -- compute the overflow damage
        local dmg = target.stat[stat] * -1

        -- zero the disabled system
        target.stat[stat] = 0

        -- recursively damage the next system
        local sys = target:functional()
        self:attack(target, sys, dmg, idx, true)
    end
end

-- Return true if the unit has moved
function Unit:moved()
    return self.act.mov
end

-- Return true if the unit has attacked
function Unit:attacked()
    return self.act.atk
end

-- Return true if a unit can no longer be used
function Unit:exhausted()
    return self.act.mov and self.act.atk
end

-- Refresh the unit
function Unit:refresh()
    self.active = true
    self.act.atk = false
    self.act.mov = false
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

-- Return true if the unit is a friend
function Unit:friend(player)
    return self.player == player
end

-- Return true if the unit is an enemy
function Unit:foe(player)
    return self.player ~= player
end

-- Return the first functional unit system
function Unit:functional()
    for _, stat in ipairs({'atk', 'rng', 'mov'}) do
        if self.stat[stat] >= 1 then return stat end
    end
end

-- Die kills a unit
function Unit.die(idx, units)
    deli(units, idx)
end

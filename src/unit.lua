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
    u.stat = u.stat or {atk = 3, rng = 3, mov = 4}

    -- compute the pixel position from the cell position
    u.pxx = u.cellx * 8
    u.pxy = u.celly * 8

    -- initialize `from` cells
    u.fromx = nil
    u.fromy = nil

    -- track actions taken
    u.attacked = u.attacked or false
    u.moved = u.moved or false

    -- is the unit active (ie, not exhausted)
    u.active = true

    -- cache the radii
    u.radius = Radius:new()

    return u
end

-- Returns a clone (deep copy) of a unit
function Unit.clone(unit)

    local clone = {}

    -- iterate over a table's properties
    -- XXX: `radius` is a shallow copy - though it seems to work?
    for key, val in pairs(unit) do clone[key] = val end

    -- create a deep copy of `stat`
    -- TODO: I can probably refactor this
    clone.stat = {atk = unit.stat.atk, mov = unit.stat.mov, rng = unit.stat.rng}

    -- initialize and return a cloned unit
    return Unit:new(clone)
end

-- Move moves a unit
function Unit:move(x, y)
    self.fromx, self.fromy = self.cellx, self.celly
    self.cellx, self.celly, self.moved = x, y, true
end

-- Reverses the prior move
function Unit:unmove(state)
    -- move the unit to its `from` position
    self.cellx, self.celly = self.fromx, self.fromy

    -- clear the `from` position
    self.fromx, self.fromy = nil, nil

    -- place the cursor back atop the unit
    state.player.cursor.cellx, state.player.cursor.celly = self.cellx,
                                                           self.celly
    -- refresh all units on this unit's team
    for _, unit in pairs(state.stage.units) do
        if unit.player == self.player then
            unit.active, unit.attacked, unit.moved = true, false, false
        end
    end
end

-- Attack attacks a unit
function Unit:attack(target, stat, atk, def, overflow, state)
    -- record that the unit has attacked
    self.attacked = true

    -- set the attacking player's cursor position atop the attacking unit
    -- (This is a QOL feature for the next turn.)
    state.player.cursor.cellx = self.cellx
    state.player.cursor.celly = self.celly

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

    -- if the enemy still has power, but none of that power is allocated to
    -- systems, do not attempt to subtract power from a system
    if target.stat.atk == 0 and target.stat.rng == 0 and target.stat.mov == 0 then
        return false
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

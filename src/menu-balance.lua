Menus.Balance = {choices = {"atk", "rng", "mov"}, sel = 1, unit = nil}

-- open the balance menu
function Menus.Balance:open(unit, idx, state)
    -- reset the menu selection
    self.sel = 1

    -- show the menu
    state.menu = self

    -- bind params
    self.orig, self.unit, self.idx = Unit.clone(unit), Unit.clone(unit), idx
end

-- update balance menu state
function Menus.Balance:update(state, inputs)
    -- get the current unit
    self.unit = state.stage.units[self.idx]

    -- for convenience
    local player, radius, stage, unit = state.player, self.unit.radius,
                                        state.stage, self.unit

    -- cancel the balance and close the menu
    if inputs.no:once() then
        state.stage.units[self.idx] = self.orig
        state.menu, self.unit, self.orig = nil, nil, nil
        return
    end

    -- move the stat selector
    if inputs.up:rep() and self.sel >= 2 then
        self.sel = self.sel - 1
    elseif inputs.down:rep() and self.sel <= 2 then
        self.sel = self.sel + 1
    end

    -- determine how much power has been allocated
    local alloc = 0
    for _, stat in pairs(self.choices) do alloc = alloc + unit.stat[stat] end

    -- get the selected stat
    local stat = self.choices[self.sel]

    -- adjust power levels
    if inputs.left:rep() and unit.stat[stat] >= 1 then
        SFX:play('power-down')
        unit.stat[stat] = unit.stat[stat] - 1
        radius:update(unit, stage, player.num)
    elseif inputs.right:rep() and unit.stat[stat] < 5 and alloc < unit.pwr then
        SFX:play('power-up')
        unit.stat[stat] = unit.stat[stat] + 1
        radius:update(unit, stage, player.num)
    end

    -- accept the balance, close the menu, and end the turn
    -- update the unit and end the turn if and only if the unit stats have
    -- been modified
    if self:changed() then
        Info:set("confirm", "cancel", unit)
        if inputs.yes:once() then
            stage.units[self.idx] = Unit.clone(unit)
            player:turnEnd(state)
            self.unit, state.menu = nil, nil
        end
    else
        Info:set("cancel", "cancel", unit)
        if inputs.yes:once() then self.unit, state.menu = nil, nil end
    end
end

function Menus.Balance:changed()
    local unit, orig = self.unit.stat, self.orig.stat

    return not (unit.atk == orig.atk and unit.rng == orig.rng and unit.mov ==
               orig.mov)
end

-- draw the "power balance" menu
function Menus.Balance:draw(state)
    Menus.Stat.draw(self, state, true)
end

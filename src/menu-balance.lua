Menus.Balance = {choices = {"atk", "rng", "mov"}, sel = 1, unit = nil}

-- open the balance menu
-- TODO: refactor away `idx` if possible
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
    self.sel = Menu.select(self, inputs)

    -- determine how much power has been allocated
    local alloc = 0
    for _, stat in pairs(self.choices) do alloc = alloc + unit.stat[stat] end

    -- get system stats
    local stat = self.choices[self.sel]
    local sys = unit.stat[stat]

    -- adjust power levels
    if inputs.left:rep() and sys >= 1 then
        sfx(0, -1, 5, 4)
        unit.stat[stat] = sys - 1
        radius:update(unit, state, player.num)
    elseif inputs.right:rep() and sys < 5 and alloc < unit.pwr then
        sfx(0, -1, 0, 4)
        unit.stat[stat] = sys + 1
        radius:update(unit, state, player.num)
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

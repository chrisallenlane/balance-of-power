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
            player:turn_end(state)
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
    -- padding to align the menu location with the camera
    local camMarginX, camMarginY = state.camera.px.x, state.camera.px.y

    -- the menu dimensions
    local menuWidth, menuHeight, menuPad = 62, 36, 4

    -- padding applied inside the camera box
    local menuMarginX = (128 - menuWidth) / 2
    local menuMarginY = (128 - menuHeight) / 2

    -- padding applied between rows
    local rowPadY = 0

    -- draw the menu background
    rectfill(camMarginX + menuMarginX, camMarginY + menuMarginY,
             camMarginX + menuMarginX + menuWidth,
             camMarginY + menuMarginY + menuHeight, 0)

    -- sum the stat powers
    local alloc = 0

    -- draw the menu text
    for _, stat in pairs(self.choices) do
        -- read the unit's stat power level
        local power = self.unit.stat[stat]

        -- add the power to the sum
        alloc = alloc + power

        -- generate a bar representing the power level
        local bar = ""
        for _ = 1, power do bar = bar .. "\150" end

        -- choose the appropriate color for the stat label
        local color = 5
        if self.choices[self.sel] == stat then color = 7 end

        -- print the stat labels
        print(stat .. ":", camMarginX + menuMarginX + menuPad,
              camMarginY + menuMarginY + menuPad + rowPadY, color)

        -- choose an appropriate color for the power bar
        color = 8 -- red (default)
        if power == 5 then
            color = 11 -- green
        elseif power >= 3 then
            color = 10 -- yellow
        end

        -- draw the bar
        print(bar, camMarginX + menuMarginX + menuPad + 16,
              camMarginY + menuMarginY + menuPad + rowPadY, color)

        -- create space for the next row
        rowPadY = rowPadY + 8
    end

    -- draw the remaining power
    print("rem:" .. self.unit.pwr - alloc, camMarginX + menuMarginX + menuPad,
          camMarginY + menuMarginY + menuPad + rowPadY, 6)
end

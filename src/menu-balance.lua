Menus.Balance = {choices = {"atk", "rng", "mov"}, sel = 1, unit = nil}

-- open the balance menu
function Menus.Balance:open(unit, idx)
    -- reset the menu selection
    self.sel = 1

    -- show the menu
    self.vis = true

    -- bind params
    self.unit = Unit.clone(unit)
    self.orig = Unit.clone(unit)
    self.idx = idx
end

-- update "end turn?" menu state
function Menus.Balance:update(state, inputs)
    -- cancel the balance and close the menu
    if inputs.no:once() then
        self.vis = false
        self.unit = nil
        Radius:update(state.cursor.sel, state.map, Player.num)
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
    for _, stat in pairs(self.choices) do
        alloc = alloc + self.unit.stat[stat]
    end

    -- get the selected stat
    local stat = self.choices[self.sel]

    -- adjust power levels
    if inputs.left:rep() and self.unit.stat[stat] >= 1 then
        SFX:play('power-down')
        self.unit.stat[stat] = self.unit.stat[stat] - 1
        Radius:update(self.unit, state.map, Player.num)
    elseif inputs.right:rep() and self.unit.stat[stat] < 5 and alloc <
        self.unit.pwr then
        SFX:play('power-up')
        self.unit.stat[stat] = self.unit.stat[stat] + 1
        Radius:update(self.unit, state.map, Player.num)
    end

    -- accept the balance, close the menu, and end the turn
    -- update the unit and end the turn if and only if the unit stats have
    -- been modified
    if self:changed() then
        Info:set("confirm", "cancel", self.unit)
        if inputs.yes:once() then
            state.map.units[self.idx] = Unit.clone(self.unit)
            Player:turn_end(state)
            self.vis = false
            self.unit = nil
        end
    else
        Info:set("cancel", "cancel", self.unit)
        if inputs.yes:once() then
            self.vis = false
            self.unit = nil
        end
    end
end

function Menus.Balance:changed()
    return
        not (self.unit.stat.atk == self.orig.stat.atk and self.unit.stat.rng ==
            self.orig.stat.rng and self.unit.stat.mov == self.orig.stat.mov)
end

-- draw the "power balance" menu
function Menus.Balance:draw(state)
    -- exit early if the menu is not visible
    if not self.vis or not self.unit then return end

    -- padding to align the menu location with the camera
    local camMarginX = state.camera.px.x
    local camMarginY = state.camera.px.y

    -- the menu dimensions
    local menuWidth = 62
    local menuHeight = 36

    -- padding applied inside the camera box
    local menuMarginX = (128 - menuWidth) / 2
    local menuMarginY = (128 - menuHeight) / 2
    local menuPad = 4

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

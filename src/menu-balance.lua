MenuBalance = {choices = {"atk", "rng", "mov"}, sel = 1, unit = nil}

-- open the balance menu
function MenuBalance:open(unit, idx)
    -- reset the menu selection
    self.sel = 1

    -- show the menu
    self.vis = true

    -- bind params
    self.unit = Unit.clone(unit)
    self.idx = idx
end

-- update "end turn?" menu state
function MenuBalance:update()
    -- cancel the balance and close the menu
    if BtnNo:once() then
        self.vis = false
        self.unit = nil
        Radius:update(Cursor.sel, Map.current, Turn.player)
        return
    end

    -- move the stat selector
    if BtnUp:rep() and self.sel >= 2 then
        self.sel = self.sel - 1
    elseif BtnDown:rep() and self.sel <= 2 then
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
    if BtnLeft:rep() and self.unit.stat[stat] >= 1 then
        SFX:play('power-down')
        self.unit.stat[stat] = self.unit.stat[stat] - 1
        Radius:update(self.unit, Map.current, Turn.player)
    elseif BtnRight:rep() and self.unit.stat[stat] < 5 and alloc < self.unit.pwr then
        SFX:play('power-up')
        self.unit.stat[stat] = self.unit.stat[stat] + 1
        Radius:update(self.unit, Map.current, Turn.player)
    end

    -- accept the balance, close the menu, and end the turn
    if BtnYes:once() then
        Map.current.units[self.idx] = Unit.clone(self.unit)
        self.vis = false
        self.unit = nil
        Turn:turn_end()
    end
end

-- draw the "power balance" menu
function MenuBalance:draw()
    -- exit early if the menu is not visible
    if not self.vis or not self.unit then return end

    -- padding to align the menu location with the camera
    local camMarginX = Camera.px.x
    local camMarginY = Camera.px.y

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

MenuTarget = {choices = {"atk", "rng", "mov"}, sel = 1, idx = nil, unit = nil}

-- TODO: disallow targeting a system with 0 power
-- update "end turn?" menu state
function MenuTarget:update()
    -- cancel the balance and close the menu
    if BtnZ:once() then
        self.vis = false
        self.unit = nil
        self.idx = nil
        return
    end

    -- move the stat selector
    if BtnUp:rep() and self.sel >= 2 then
        self.sel = self.sel - 1
    elseif BtnDown:rep() and self.sel <= 2 then
        self.sel = self.sel + 1
    end

    -- accept the balance, close the menu, and end the turn
    if BtnX:once() then
        -- hide this menu
        self.vis = false

        -- attack the enemy unit
        Cursor.sel:attack(self.unit, self.choices[self.sel],
                          Cursor.sel.stat.atk, self.idx)

        -- deactivate all *other* units belonging to the player
        Units.deactivate(Map.current.units, Turn.player)
        Cursor.sel:activate()

        -- end the player's turn if the unit is exhausted
        if Cursor.sel:exhausted() then
            Turn:turn_end()
            -- otherwise, show the movement radius
        else
            Radius:update(Cursor.sel, Map.current, Turn.player)
        end
    end
end

-- draw the "power balance" menu
function MenuTarget:draw()
    -- exit early if the menu is not visible
    if not self.vis or not self.unit then return end

    -- padding to align the menu location with the camera
    local camMarginX = Camera.px.x
    local camMarginY = Camera.px.y

    -- the menu dimensions
    local menuWidth = 62
    local menuHeight = 28

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
end

MenuBalance = {choices = {"atk", "rng", "spd"}, sel = 1}

-- update "end turn?" menu state
function MenuBalance:update()
    -- close the menu if "Z" is pressed
    if BtnZ:rep(4) then self.vis = false end

    -- TODO: make the menu function
end

-- draw the "power balance" menu
function MenuBalance:draw(unit)
    -- exit early if the menu is not visible
    if not self.vis then return end

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
    local sum = 0

    -- draw the menu text
    for _, stat in pairs(self.choices) do
        -- read the unit's stat power level
        local power = unit.stat[stat]

        -- add the power to the sum
        sum = sum + power

        -- generate a bar representing the power level
        local bar = ""
        for _ = 1, power do bar = bar .. "\150" end

        -- choose an appropriate color for the power bar
        local color = 8 -- red (default)
        if power == 5 then
            color = 11 -- green
        elseif power >= 3 then
            color = 10 -- yellow
        end

        -- print the stat labels
        print(stat .. ":", camMarginX + menuMarginX + menuPad,
              camMarginY + menuMarginY + menuPad + rowPadY, 7)

        -- draw the bar
        print(bar, camMarginX + menuMarginX + menuPad + 16,
              camMarginY + menuMarginY + menuPad + rowPadY, color)

        -- create space for the next row
        rowPadY = rowPadY + 8
    end

    -- draw the remaining power
    print("rem:" .. sum, camMarginX + menuMarginX + menuPad,
          camMarginY + menuMarginY + menuPad + rowPadY, 7)
end

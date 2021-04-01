Info = {yes = "", no = "", unit = nil}

-- Set info values
function Info:set(yes, no, unit)
    self.yes, self.no, self.unit = yes, no, unit
end

-- Draw the info box
function Info:draw(state)
    local yes, no = self.yes, self.no

    -- short circuit if there is no info to display
    if yes == "" and no == "" then return end

    -- padding to align the menu location with the camera
    local camX, camY = state.camera.px.x, state.camera.px.y

    -- text position
    local textY = camY + 120

    -- draw the menu background
    rectfill(camX, camY + 117, camX + 128, camY + 128, 0)

    -- if both buttons do the same thing, combine them
    if yes ~= "" and yes == no then
        print("\142", camX + 4, textY, 5)
        print("/", camX + 12, textY, 7)
        print("\151", camX + 16, textY, 5)
        print(yes, camX + 25, textY, 7)
    else
        -- confirm
        if yes ~= "" then
            print("\142", camX + 4, textY, 5)
            print(yes, camX + 13, textY, 7)
        end

        -- cancel
        if no ~= "" then
            print("\151", camX + 17 + (#yes * 4), textY, 5)
            print(no, camX + 26 + (#yes * 4), textY, 7)
        end
    end

    -- output the unit hud if applicable
    if self.unit then
        local stat = self.unit.stat

        -- atk
        print("a", camX + 99, textY, 7)
        print(stat.atk, camX + 103, textY, self.colorize(stat.atk))

        -- mov
        print("m", camX + 117, textY, 7)
        print(stat.mov, camX + 121, textY, self.colorize(stat.mov))

        -- rng
        print("r", camX + 108, textY, 7)
        print(stat.rng, camX + 112, textY, self.colorize(stat.rng))
    end
end

-- Return a color value based on a stat value
function Info.colorize(val)
    if val == 5 then
        return 11 -- green
    elseif val >= 3 then
        return 10 -- yellow
    end

    return 8
end

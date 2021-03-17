Info = {yes = "", no = "", unit = nil}

-- Set info values
function Info:set(yes, no, unit)
    self.yes = yes
    self.no = no
    self.unit = unit
end

-- Draw the info box
function Info:draw()
    -- short circuit if there is no info to display
    if self.yes == "" and self.no == "" then return end

    -- padding to align the menu location with the camera
    local camX = State.camera.px.x
    local camY = State.camera.px.y

    -- draw the menu background
    rectfill(camX, camY + 117, camX + 128, camY + 128, 0)

    -- if both buttons do the same thing, combine them
    if self.yes ~= "" and self.yes == self.no then
        print("\142", camX + 4, camY + 120, 5)
        print("/", camX + 12, camY + 120, 7)
        print("\151", camX + 16, camY + 120, 5)
        print(self.yes, camX + 25, camY + 120, 7)
    else
        -- confirm
        if self.yes ~= "" then
            print("\142", camX + 4, camY + 120, 5)
            print(self.yes, camX + 13, camY + 120, 7)
        end

        -- cancel
        if self.no ~= "" then
            print("\151", camX + 17 + (#self.yes * 4), camY + 120, 5)
            print(self.no, camX + 26 + (#self.yes * 4), camY + 120, 7)
        end
    end

    -- output the unit hud if applicable
    if self.unit then
        -- atk
        print("a", camX + 99, camY + 120, 7)
        print(self.unit.stat.atk, camX + 103, camY + 120,
              self.colorize(self.unit.stat.atk))

        -- mov
        print("m", camX + 117, camY + 120, 7)
        print(self.unit.stat.mov, camX + 121, camY + 120,
              self.colorize(self.unit.stat.mov))

        -- rng
        print("r", camX + 108, camY + 120, 7)
        print(self.unit.stat.rng, camX + 112, camY + 120,
              self.colorize(self.unit.stat.rng))
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

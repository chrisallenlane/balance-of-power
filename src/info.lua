Info = {yes = "", no = ""}

-- Set info values
function Info:set(yes, no)
    self.yes = yes
    self.no = no
end

-- Draw the info box
function Info:draw()
    -- short circuit if there is no info to display
    if self.yes == "" and self.no == "" then return end

    -- padding to align the menu location with the camera
    local camX = Camera.px.x
    local camY = Camera.px.y

    -- draw the menu background
    rectfill(camX, camY + 117, camX + 128, camY + 128, 0)

    -- if both buttons do the same thing, combine them
    if self.yes ~= "" and self.yes == self.no then
        print("\142", camX + 4, camY + 120, 5)
        print("/", camX + 12, camY + 120, 7)
        print("\151", camX + 16, camY + 120, 5)
        print(self.yes, camX + 25, camY + 120, 7)
        return
    end

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

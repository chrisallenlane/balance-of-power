Info = {yes = "", no = "", unit = nil}

-- Set info values
function Info:set(yes, no, unit)
    self.yes, self.no, self.unit = yes, no, unit
end

-- Draw the info box
function Info:draw(state)
    -- hide the info bar if it would occlude the cursor
    if state.player.cursor.cell.y == state.stage.cell.h - 1 then return end

    local yes, no = self.yes, self.no

    -- short circuit if there is no info to display
    if yes == "" and no == "" then return end

    -- padding to align the menu location with the camera
    local camX, camY = state.camera.pxx, state.camera.pxy

    -- text position
    local textY = camY + 122

    -- draw the menu background
    rectfill(camX, camY + 120, camX + 128, camY + 128, 0)

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
    else
        local cell, stage = state.player.cursor.cell, state.stage
        local x, y = cell.x, cell.y
        local cost, def = Cell.cost(x, y, stage), Cell.def(x, y, stage)

        -- draw the tile of interest into the Info bar
        -- implement any specified palette swaps for the stage
        Stage.palswap(state)
        spr(mget(stage.cell.x + x, stage.cell.y + y), state.camera.pxx + 99,
            textY, .70, .70)
        pal()

        -- movement cost
        print("m", camX + 106, textY, 7)
        Info.arrow((cost - 1) * -1, camX + 110, textY)

        -- defensive modifier
        print("d", camX + 117, textY, 7)
        Info.arrow(def, camX + 121, textY)
    end
end

function Info.arrow(val, x, y)
    if val > 0 then
        sspr(32, 0, 5, 3, x, y)
    elseif val == 0 then
        sspr(32, 3, 5, 1, x, y + 2)
    elseif val < 0 then
        sspr(32, 4, 5, 3, x, y + 2)
    end
end

-- Return a color value based on a stat value
function Info.colorize(val)
    return val == 5 and 11 or val >= 3 and 10 or 8
end

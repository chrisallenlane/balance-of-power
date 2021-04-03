Menus.Target = {choices = {"atk", "rng", "mov"}, sel = 1, idx = nil, unit = nil}

-- open the target menu
function Menus.Target:open(unit, idx, state)
    -- reset the menu selection
    self.sel = 1

    -- show the menu
    state.menu = self

    -- bind params
    self.idx, self.unit = idx, unit
end

-- TODO: disallow targeting a system with 0 power
-- update "end turn?" menu state
function Menus.Target:update(state, inputs)
    Info:set("target", "cancel", self.unit)

    -- reclaim tokens
    local player, stage = state.player, state.stage
    local sel, units = player.cursor.unit.sel, stage.units

    -- cancel the balance and close the menu
    if inputs.no:once() then
        self.idx, self.unit, state.menu = nil, nil, nil
        return
    end

    -- move the stat selector
    if inputs.up:rep() and self.sel >= 2 then
        self.sel = self.sel - 1
    elseif inputs.down:rep() and self.sel <= 2 then
        self.sel = self.sel + 1
    end

    -- accept the balance, close the menu, and end the turn
    if inputs.yes:once() then
        -- hide this menu
        state.menu = nil

        -- deactivate all *other* units belonging to the player
        Units.deactivate(units, player.num)
        sel:activate()

        -- attack the enemy unit
        Seq:enqueue({Anim.laser(sel, self.unit)})
        local killed = sel:attack(self.unit, self.choices[self.sel],
                                  sel.stat.atk, Cell.def(self.unit.cell.x,
                                                         self.unit.cell.y, stage))

        if not killed then
            -- update the unit radius
            sel.radius:update(sel, stage, player.num)

            -- end the player's turn if the unit is exhausted
            if sel:moved() or sel.stat.mov == 0 then
                player:turnEnd(state)
            end
            return
        end

        -- delete the enemy unit if it has been destroyed
        Seq:enqueue({
            Anim.explode(self.unit, state),
            function()
                Units.die(self.idx, units)
                -- update the unit radius
                sel.radius:update(sel, stage, player.num)

                -- end the player's turn if the unit is exhausted
                if sel:moved() or sel.stat.mov == 0 then
                    player:turnEnd(state)
                end
                return true
            end,
        })
    end
end

-- draw the "power balance" menu
function Menus.Target:draw(state)
    -- padding to align the menu location with the camera
    local camMarginX, camMarginY = state.camera.px.x, state.camera.px.y

    -- the menu dimensions
    local menuWidth, menuHeight = 62, 28

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

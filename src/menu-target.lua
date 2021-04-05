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
        local def = Cell.def(self.unit.cell.x, self.unit.cell.y, stage)
        local killed = sel:attack(self.unit, self.choices[self.sel],
                                  sel.stat.atk, def, false, state)

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

-- draw the "target" menu
function Menus.Target:draw(state)
    Menus.Stat.draw(self, state, false)
end

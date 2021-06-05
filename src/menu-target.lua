Menus.Target = {choices = {"atk", "rng", "mov"}, sel = 1, unit = nil}

-- open the target menu
function Menus.Target:open(unit, state)
    -- reset the menu selection
    self.sel = 1

    -- show the menu
    state.menu = self

    -- bind params
    self.unit = unit
end

-- @todo: disallow targeting a system with 0 power
-- update targeting menu state
function Menus.Target:update(state, inputs)
    Info:set("target", "cancel", self.unit)

    -- reclaim tokens
    local player, stage = state.player, state.stage
    local sel, units = player.cursor.unit.sel, stage.units

    -- cancel the balance and close the menu
    if inputs.no:once() then
        self.unit, state.menu = nil, nil
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

        local def = Cell.def(self.unit.cell.x, self.unit.cell.y, stage)
        local killed = sel:attack(self.unit, self.choices[self.sel],
                                  sel.stat.atk, def, false, state)

        -- hide the attacker's radii
        sel.radius.vis = false

        -- attack the enemy unit
        Seq:enqueue({Anim.laser(sel, self.unit)})

        -- kill the enemy unit if it was destroyed
        if killed then
            Seq:enqueue({
                function()
                    Units.die(self.unit.id, units)
                    return true
                end,
                Anim.explode(self.unit.px.x, self.unit.px.y, state),
                Anim.delay(30),
            })
        end

        Seq:enqueue({
            function()
                if not sel:moved() and sel.stat.mov >= 1 then
                    sel.radius:update(sel, stage, player.num)
                else
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

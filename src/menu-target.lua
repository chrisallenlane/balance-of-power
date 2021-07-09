Menus.Target = {choices = {'atk', 'rng', 'mov'}, sel = 1, unit = nil}

-- open the target menu
function Menus.Target:open(unit, state)
  -- reset the menu selection
  self.sel = 1

  -- show the menu
  state.menu = self

  -- bind params
  self.unit = unit
end

-- TODO: disallow targeting a system with 0 power
-- update targeting menu state
function Menus.Target:update(state, inputs)
  Info:set('target', 'cancel', self.unit)

  -- reclaim tokens
  local player, stage = state.player, state.stage
  local sel, units = player.cursor.unit.sel, stage.units

  -- cancel the balance and close the menu
  if inputs.no:once() then
    self.unit, state.menu = nil, nil
    return
  end

  -- move the stat selector
  self.sel = Menu.select(self, inputs)

  -- accept the target and attack
  -- TODO DRY: this should all be moved "up" a level
  if inputs.yes:once() then
    -- hide this menu
    state.menu = nil

    -- deactivate all *other* units belonging to the player
    Units.deactivate(units, player.num)
    sel:activate()

    -- attack the target and enqeue the resultant animations
    Seq:enqueue(Player.attack(sel, self.unit, self.choices[self.sel], state))
  end
end

-- draw the "target" menu
function Menus.Target:draw(state)
  Menus.Stat.draw(self, state, false)
end

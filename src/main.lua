function _init()
  -- set up cartridge persistence
  cartdata('mudbound_dragon_balance_of_power_v_alpha')

  -- load autosave data
  State.savedStage = dget(0)
  if State.savedStage ~= 0 then add(Menus.Title.choices, 'continue') end

  -- implement "invert buttons" function
  menuitem(
    1, 'invert btns ' .. (dget(1) == 1 and 'yes' or 'no'), function()
      Inputs:invert()
      dset(1, dget(1) == 1 and 0 or 1)
      menuitem(1, 'invert btns ' .. (dget(1) == 1 and 'yes' or 'no'))
      return true
    end
  )

  -- implement a "reset stage" menu function
  menuitem(
    2, 'reset stage', function()
      Stage.load(State.stage.num, Stages, Screens, State)
    end
  )

  -- implement an "advance stage" debug function
  if DEBUG_CHEAT then
    menuitem(
      3, 'advance stage', function()
        State.stage:advance(Stages, Screens, State)
      end
    )
  end

  -- build an in-memory table of cell traversal costs
  Cell.data = Cell.init()

  -- unserialize stage data
  Stages = Stage.unserialize(StageData)

  -- invert the "yes" and "no" buttons if so configured
  if dget(1) == 1 then Inputs:invert() end
end

function _update60()
  State.frame = State.frame + 1
  Inputs:poll(State.player.num or 1)
  State.screen.update(State, Inputs)
end

function _draw()
  State.screen.draw(State)
end

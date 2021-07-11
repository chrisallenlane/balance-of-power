-- update the battle screen
function Screens.battle.update(state, inputs)
  -- reclaim tokens
  local seq = state.seq

  -- return early if a sequence is playing
  if #seq.queue > 0 then return end

  -- have the camera follow the cursor
  state.camera:follow(state)
  state.camera:update(state)

  -- determine if the stage has been cleared
  local clear, victor = Stage.clear(state)

  -- handle stage clears
  if clear then
    Info:set('', '')
    Units.refresh(state.stage.units)
    seq:add({Anim.delay(120)})

    -- handle 1-player games
    if state.players[2].cpu then
      if victor == 1 then
        -- show player 1 "victory" banner for 300 frames, then advance to the next stage
        seq:add(
          {
            Banner:display(1, 'victory', 300),
            function()
              -- TODO: display all `clear` talk boxes
              -- TODO: delay
              -- TODO: after the talk is clear and then the delay, advance the
              --       stage
              state.stage:advance(Stages, Screens, state)
            end,
          }
        )
      else
        -- show player 1 "defeat" banner for 300 frames, then show the "defeat" screen
        seq:add(
          {
            Banner:display(2, 'defeat', 300),
            function()
              state.screen = Screens.defeat
            end,
          }
        )
      end

      -- handle 2-player games
    else
      -- display the winning player's banner, then go to the title screen
      seq:add(
        {
          Banner:display(victor, 'player ' .. victor .. ' victory', 300),
          function()
            state.screen = Screens.title
          end,
        }
      )
    end

    return
  end

  -- run the command loop
  if state.player:human(state.players) then
    -- direct inputs to the `talk` box if displayed
    -- TODO: integrate clear talk into this loop somehow
    if state.talk.vis then
      state.talk:update(state, inputs)
      return
    end

    -- update the menu if it is visible
    if state.menu then
      state.menu:update(state, inputs)
      return
    end

    -- update the cursor state
    state.player.cursor:update(state.stage, inputs)

    -- update the battle state
    Human.battle.update(state, inputs)
  else
    CPU.battle.update(state)
  end
end

-- draw the battle screen
function Screens.battle.draw(state)
  -- move the camera
  state.camera:draw()

  -- draw the stage
  Stage.draw(state)

  -- draw unit radii
  for _, unit in pairs(state.stage.units) do
    unit.radius:draw(unit.player == state.player.num)
  end

  -- draw the cursor (if the player is a human)
  if state.player:human(state.players) then state.player.cursor:draw(state) end

  -- draw units
  Units.draw(state)

  -- draw menus
  if state.menu then state.menu:draw(state) end

  -- draw the walk window
  state.talk:draw(state)

  -- draw the victory/loss banner
  Banner:draw(state)

  -- draw the info bar
  Info:draw(state)

  -- play animations
  state.seq:play()
end

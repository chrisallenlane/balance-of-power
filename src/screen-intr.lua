function Screens.intr.update(state, inputs)
  if inputs.yes:once() then

    -- display the talk dialogue iff we're playing a single-player game
    if state.players[2].cpu then
      state.seq:add(
        {
          Anim.delay(180),
          function()
            state.talk:say(state.stage.talk.start, state)
          end,
        }
      )
    end

    state.screen = Screens.battle
  end
end

function Screens.intr.draw(state)
  cls()
  String.centerX(state.stage.intr.head, 41, 7, state)
  String.centerX(state.stage.intr.body, 55, 7, state)
  camera(state.camera.pxx, state.camera.pxy)
end

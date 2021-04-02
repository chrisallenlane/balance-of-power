function Screens.intr.update(state, inputs)
    if inputs.yes:once() then state.screen = Screens.battle end
end

function Screens.intr.draw(state)
    cls()
    rectfill(0, 0, 127, 127, 0)
    String.centerX(state.stage.intr.head, 41, 7, state)
    String.centerX(state.stage.intr.body, 55, 7, state)
    camera(0, 0)
end

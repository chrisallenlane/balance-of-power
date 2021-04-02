function Screens.intr.update(state, inputs)
    if inputs.yes:once() then state.screen = Screens.battle end
end

function Screens.intr.draw(state)
    cls()
    String.centerX(state.stage.intr.head, 41, 7, state)
    String.centerX(state.stage.intr.body, 55, 7, state)
    camera(state.camera.px.x, state.camera.px.y)
end

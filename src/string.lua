String = {}

-- Horizontally center `color` text at `y` vertical
function String.centerX(str, y, color, state, pr)
    pr = pr or print
    return pr(str, ((128 - (#str * 4)) / 2) + state.camera.px.x,
              y + state.camera.px.y, color)
end

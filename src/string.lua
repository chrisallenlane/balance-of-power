String = {}

-- Horizontally center `color` text at `y` vertical
function String.centerX(str, y, color, state)
  return print(
           str, ((128 - (#str * 4)) / 2) + state.camera.pxx,
           y + state.camera.pxy, color
         )
end

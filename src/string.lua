String = {}

-- Horizontally center `color` text at `y` vertical
function String.centerX(str, y, color)
    print(str, (128 - (#str * 4)) / 2, y, color)
end

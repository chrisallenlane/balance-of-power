Menus.Stat = {}

-- DRY out the balance and targeting menus, which are largely the same
function Menus.Stat.draw(menu, state, remaining)
  -- padding to align the menu location with the camera
  local camx, camy = state.camera.pxx, state.camera.pxy

  -- the menu height
  local menuHeight = remaining and 36 or 28

  -- padding applied inside the camera box
  local menuMarginY = (128 - menuHeight) / 2

  -- draw the menu background
  rectfill(
    camx + 33, camy + menuMarginY, camx + 95, camy + menuMarginY + menuHeight, 0
  )

  -- sum the stat powers / pad rows
  local alloc, rowPadY = 0, 0

  -- draw the menu text
  for _, stat in pairs(menu.choices) do
    -- read the unit's stat power level
    local power = menu.unit.stat[stat]

    -- add the power to the sum
    alloc = alloc + power

    -- generate a bar representing the power level
    local bar = ''
    for _ = 1, power do bar = bar .. '\150' end

    -- choose the appropriate color for the stat label
    local color = menu.choices[menu.sel] == stat and 7 or 5

    -- print the stat labels
    print(stat .. ':', camx + 37, camy + menuMarginY + 4 + rowPadY, color)

    -- choose an appropriate color for the power bar
    color = Info.colorize(power)

    -- draw the bar
    print(bar, camx + 53, camy + menuMarginY + 4 + rowPadY, color)

    -- create space for the next row
    rowPadY = rowPadY + 8
  end

  -- draw the remaining power
  if remaining then
    print(
      'rem:' .. menu.unit.pwr - alloc, camx + 37,
      camy + menuMarginY + 4 + rowPadY, 6
    )
  end
end

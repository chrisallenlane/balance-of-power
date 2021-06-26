-- update the defeat screen
function Screens.defeat.update()
end

-- draw the defeat screen
function Screens.defeat.draw()
  rectfill(0, 0, 127, 127, 12)
  print('game over', 39, 56, 1)
  camera(0, 0)
end

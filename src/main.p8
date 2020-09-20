-- https://www.lua.org/pil/contents.html#P1
-- https://pico-8.fandom.com/wiki/APIReference

-- game table
local game = {}

function _init()
  -- TODO: load the title screen
  game.map.load(0)
end

function _update()
  game.cursor:update()
  -- XXX: this causes MEM to thrash
  game.camera:update()
  -- TODO: debugging inputs
  --  - next/prev map
end

function _draw()
  cls()
  game.map.draw()
  game.cursor:draw()
  spr(5, 8, 8)

  -- move the camera
  game.camera:move()

  -- display debug output
  debug(game)
end

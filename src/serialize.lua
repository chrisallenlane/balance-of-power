local stringx = require 'pl.stringx'
local tablex = require 'pl.tablex'

return function(stage)
  return stringx.join(
           '~', {
      -- stage number
      stage.num,

      -- interstitial text
      stringx.join('@', {stage.intr.head, stage.intr.body}),

      -- camera position
      stringx.join('@', {stage.camera.x, stage.camera.y}),

      -- map dimensions
      stringx.join('@', {stage.cell.x, stage.cell.y, stage.cell.w, stage.cell.h}),

      -- palette swaps
      stringx.join(
        '@', tablex.map(
          function(s)
            return stringx.join('@', {s[1], s[2]})
          end, stage.swap
        )
      ),

      -- units
      stringx.join(
        '@', tablex.map(
          function(u)
            return stringx.join('@', {u.player, u.x, u.y})
          end, stage.units
        )
      ),

      -- dialog
      string.lower(stringx.join('@', stage.talk.start)),
      string.lower(stringx.join('@', stage.talk.clear)),
    }
         )
end


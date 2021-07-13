local stringx = require 'pl.stringx'

_G.split = stringx.split
_G.add = table.insert

require('../src/radius')
require('../src/stage')
require('../src/unit')

describe(
  'stage', function()
    it(
      'should unserialize stage data', function()
        -- create a `split` function that behaves like the Pico-8 built-in
        local split = function(str, sep)
          local out = stringx.split(str, sep)

          for key, val in pairs(out) do
            if tonumber(val) ~= nil then out[key] = tonumber(val) end
          end

          return out
        end

        -- create serialized stage data
        local parts = {
          '1~stage 1@lorem ipsum dolor~1',
          '@2~3@4@5@6~1@2@3@4~1@7@8@1@9@10@2@11@12@2@13@14~foo bar~baz bat&',
          '2~stage 2@lorem ipsum dolor~1',
          '@2~3@4@5@6~1@2@3@4~1@7@8@1@9@10@2@11@12@2@13@14~foo bar~baz bat',
        }

        local serialized = ''
        for _, part in ipairs(parts) do serialized = serialized .. part end

        -- NB: `Stage.unserialize` returns a table of functions which return
        -- tables that represent a stage. This indirection is (I believe)
        -- necessary in order to facilitate the ability to reload a level.
        -- create functions which return the appropriate payload
        local wantFns = {
          function()
            return {
              num = '1',
              intr = {head = 'stage 1', body = 'lorem ipsum dolor'},
              camera = {cellx = '1', celly = '2'},
              cellx = '3',
              celly = '4',
              cellw = '5',
              cellh = '6',
              swap = {{'1', '2'}, {'3', '4'}},
              units = {
                Unit:new({player = '1', cellx = '7', celly = '8', id = 1}),
                Unit:new({player = '1', cellx = '9', celly = '10', id = 2}),
                Unit:new({player = '2', cellx = '11', celly = '12', id = 3}),
                Unit:new({player = '2', cellx = '13', celly = '14', id = 4}),
              },
              talk = {start = {'foo bar'}, clear = {'baz bat'}},
            }
          end,
          function()
            return {
              num = '2',
              intr = {head = 'stage 2', body = 'lorem ipsum dolor'},
              camera = {cellx = '1', celly = '2'},
              cellx = '3',
              celly = '4',
              cellw = '5',
              cellh = '6',
              swap = {{'1', '2'}, {'3', '4'}},
              units = {
                Unit:new({player = '1', cellx = '7', celly = '8', id = 1}),
                Unit:new({player = '1', cellx = '9', celly = '10', id = 2}),
                Unit:new({player = '2', cellx = '11', celly = '12', id = 3}),
                Unit:new({player = '2', cellx = '13', celly = '14', id = 4}),
              },
              talk = {start = {'foo bar'}, clear = {'baz bat'}},
            }
          end,
        }

        -- unserialize the stage data
        local gotFns = Stage.unserialize(serialized, split, table.insert)

        -- now that we have created our stage constructors, we invoke them to
        -- determine that the objects returned are shaped as expected.
        local want = {wantFns[1](), wantFns[2]()}
        local got = {gotFns[1](), gotFns[2]()}

        -- assert that the stages unserialized correctly
        assert.same(want, got)
      end
    )
  end
)

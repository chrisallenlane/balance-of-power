require('../src/radius')
require('../src/unit')

local serialize = require('../src/serialize')

describe(
  'unserialize', function()
    it(
      'should unserialize', function()
        -- mock stage data
        local stage = {
          num = 1,
          intr = {head = 'stage 1', body = 'lorem ipsum dolor'},
          camera = {x = 1, y = 2},
          cell = {x = 3, y = 4, w = 5, h = 6},
          swap = {{1, 2}, {3, 4}},
          units = {
            {player = 1, x = 7, y = 8},
            {player = 1, x = 9, y = 10},
            {player = 2, x = 11, y = 12},
            {player = 2, x = 13, y = 14},
          },
          talk = {start = {'foo bar'}, clear = {'baz bat'}},
        }

        -- specify the expectation
        local want = '1~stage 1@lorem ipsum dolor~1@2~3@4@5@6~1@2@3@4~1@7@8@1@9@10@2@11@12@2@13@14~foo bar~baz bat'
        assert.same(want, serialize(stage))
      end
    )
  end
)

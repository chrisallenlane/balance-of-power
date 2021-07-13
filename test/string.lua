-- mock the Pico-8 `print` global function
_G.print = function(str, x, y, color)
  return str, x, y, color
end

require('../src/string')

describe(
  'string', function()
    it(
      'should print a centered string', function()

        -- stub a state object
        local state = {camera = {pxx = 10, pxy = 10}}

        -- run assertions on spied values
        local str, x, y, color = String.centerX('hello, world', 64, 1, state)
        assert.equal('hello, world', str)
        assert.equal(50, x)
        assert.equal(74, y)
        assert.equal(1, color)
      end
    )
  end
)

-- mock the Pico-8 `sfx` global function
_G.sfx = function()
end

require('../src/radius')
require('../src/unit')

describe(
  'unit', function()

    describe(
      'new', function()
        it(
          'should initialize a unit', function()
            -- initialize a unit
            local u = Unit:new(
                        {spr = 1, player = 2, cellx = 3, celly = 4, id = 1}
                      )

            -- declare the expected values
            local want = {
              id = 1,
              attacked = false,
              moved = false,
              active = true,
              cellx = 3,
              celly = 4,
              fromx = nil,
              fromy = nil,
              player = 2,
              pwr = 10,
              pxx = 24,
              pxy = 32,
              deg = 0,
              step = 0.001,
              rad = 4,
              spr = 1,
              selected = false,
              radius = Radius:new(),
              stat = {atk = 3, mov = 4, rng = 3},
            }

            assert.same(want, u)
          end
        )
      end
    )

    describe(
      'clone', function()
        it(
          'should clone the unit', function()
            -- initialize a unit
            local orig = Unit:new(
                           {
                spr = 1,
                player = 2,
                cellx = 3,
                celly = 4,
                fromx = 5,
                fromy = 6,
              }
                         )
            local clone = Unit.clone(orig)

            -- assert that `clone` has the same values as `orig`
            assert.same(orig, clone)

            -- assert that `clone` is however NOT the same object
            -- (IOW: assert that a deep-copy has been made.)
            assert.is_not.equal(orig, clone)
          end
        )
      end
    )

    describe(
      'move', function()
        it(
          'should change the unit state', function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cellx = 3, celly = 4})

            -- move the unit
            u:move(5, 6)

            -- assert that the correct state changes have been made
            assert.equal(5, u.cellx)
            assert.equal(6, u.celly)
            assert.equal(true, u.moved)
          end
        )
      end
    )

    describe(
      'moved', function()
        it(
          'should report whether the unit has moved', function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cellx = 3, celly = 4})

            -- assert that the unit has not moved
            assert.equal(false, u.moved)

            -- manually move the unit
            u.moved = true

            -- assert that the unit has moved
            assert.equal(true, u.moved)
          end
        )
      end
    )

    describe(
      'attacked', function()
        it(
          'should report whether the unit has attacked', function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cellx = 3, celly = 4})

            -- assert that the unit has not attacked
            assert.equal(false, u.attacked)

            -- manually move the unit
            u.attacked = true

            -- assert that the unit has attacked
            assert.equal(true, u.attacked)
          end
        )
      end
    )
  end
)

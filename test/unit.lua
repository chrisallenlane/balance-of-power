require("../src/radius")
require("../src/unit")

describe("unit", function()

    describe("new", function()
        it("should initialize a unit", function()
            -- initialize a unit
            local u = Unit:new({
                spr = 1,
                player = 2,
                cell = {x = 3, y = 4},
                id = 1,
            })

            -- declare the expected values
            local want = {
                id = 1,
                act = {atk = false, mov = false},
                active = true,
                cell = {x = 3, y = 4},
                from = {x = nil, y = nil},
                player = 2,
                pwr = 10,
                px = {x = 24, y = 32},
                spr = 1,
                radius = Radius:new(),
                stat = {atk = 5, mov = 3, rng = 2},
            }

            assert.same(want, u)
        end)
    end)

    describe("clone", function()
        it("should clone the unit", function()
            -- initialize a unit
            local orig = Unit:new({
                spr = 1,
                player = 2,
                cell = {x = 3, y = 4},
                from = {x = 5, y = 6},
            })
            local clone = Unit.clone(orig)

            -- assert that `clone` has the same values as `orig`
            assert.same(orig, clone)

            -- assert that `clone` is however NOT the same object
            -- (IOW: assert that a deep-copy has been made.)
            assert.is_not.equal(orig, clone)
        end)
    end)

    describe("move", function()
        it("should change the unit state", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- move the unit
            u:move(5, 6)

            -- assert that the correct state changes have been made
            assert.equal(5, u.cell.x)
            assert.equal(6, u.cell.y)
            assert.equal(true, u.act.mov)
        end)
    end)

    describe("moved", function()
        it("should report whether the unit has moved", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- assert that the unit has not moved
            assert.equal(false, u:moved())

            -- manually move the unit
            u.act.mov = true

            -- assert that the unit has moved
            assert.equal(true, u:moved())
        end)
    end)

    describe("attacked", function()
        it("should report whether the unit has attacked", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- assert that the unit has not attacked
            assert.equal(false, u:attacked())

            -- manually move the unit
            u.act.atk = true

            -- assert that the unit has attacked
            assert.equal(true, u:attacked())
        end)
    end)

    describe("acted", function()
        it("should report whether a unit has acted", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- reset the unit's action flags
            local refresh = function(unit)
                unit.act.atk = false
                unit.act.mov = false
            end

            -- assert that the negative case is reported correctly
            assert.equal(false, u:acted())

            -- manually attack
            u.act.atk = true
            assert.equal(true, u:acted())

            -- reset the unit
            refresh(u)

            -- manually move
            u.act.mov = true
            assert.equal(true, u:acted())

            -- reset the unit
            refresh(u)

            -- manually attack and move
            u.act.atk = true
            u.act.mov = true
            assert.equal(true, u:acted())
        end)
    end)
end)

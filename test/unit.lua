require("../src/radius")
require("../src/unit")

describe("unit", function()

    describe("new", function()
        it("should initialize a unit", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- declare the expected values
            local expect = {
                act = {atk = false, mov = false},
                active = true,
                cell = {x = 3, y = 4},
                player = 2,
                pwr = 10,
                px = {x = 24, y = 32},
                spr = 1,
                radius = Radius:new(),
                stat = {atk = 5, mov = 3, rng = 2},
            }

            assert.same(u, expect)
        end)
    end)

    describe("clone", function()
        it("should clone the unit", function()
            -- initialize a unit
            local orig = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})
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
            assert.equal(u.cell.x, 5)
            assert.equal(u.cell.y, 6)
            assert.equal(u.act.mov, true)
        end)
    end)

    describe("moved", function()
        it("should report whether the unit has moved", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- assert that the unit has not moved
            assert.equal(u:moved(), false)

            -- manually move the unit
            u.act.mov = true

            -- assert that the unit has moved
            assert.equal(u:moved(), true)
        end)
    end)

    describe("attacked", function()
        it("should report whether the unit has attacked", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- assert that the unit has not attacked
            assert.equal(u:attacked(), false)

            -- manually move the unit
            u.act.atk = true

            -- assert that the unit has attacked
            assert.equal(u:attacked(), true)
        end)
    end)

    describe("refresh", function()
        it("should reset the unit action flags", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- manually exhaust the unit
            u.active = false
            u.act.atk = true
            u.act.mov = true

            -- refresh the unit
            u:refresh()

            -- assert that the unit has been refreshed
            assert.equal(u.active, true)
            assert.equal(u.act.atk, false)
            assert.equal(u.act.mov, false)
        end)
    end)

    describe("acted", function()
        it("should report whether a unit has acted", function()
            -- initialize a unit
            local u = Unit:new({spr = 1, player = 2, cell = {x = 3, y = 4}})

            -- reset the unit's action flags
            local refresh = function(u)
                u.act.atk = false
                u.act.mov = false
            end

            -- assert that the negative case is reported correctly
            assert.equal(u:acted(), false)

            -- manually attack
            u.act.atk = true
            assert.equal(u:acted(), true)

            -- reset the unit
            refresh(u)

            -- manually move
            u.act.mov = true
            assert.equal(u:acted(), true)

            -- reset the unit
            refresh(u)

            -- manually attack and move
            u.act.atk = true
            u.act.mov = true
            assert.equal(u:acted(), true)
        end)
    end)
end)

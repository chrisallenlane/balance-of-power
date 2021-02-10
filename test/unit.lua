require("../src/unit")

describe("unit", function()
    it("should should correctly initialize", function()
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
            stat = {atk = 5, mov = 3, rng = 2},
        }

        assert.are.same(u, expect)
    end)
end)

require("../src/radius")
require("../src/unit")
require("../src/units")

describe("unit", function()

    describe("at", function()
        it("should return the unit at coordinates", function()
            -- initialize the units
            local needle =
                Unit:new({spr = 80, player = 1, cellx = 2, celly = 2})
            local haystack = {
                Unit:new({spr = 80, player = 1, cellx = 1, celly = 1}),
                needle,
            }

            -- search for the unit
            local unit, idx = Units.at(2, 2, haystack)

            -- assert
            assert.equal(needle, unit)
            assert.equal(2, idx)
        end)

        it("should return nil if no unit is found", function()
            -- initialize the units
            local haystack = {
                Unit:new({spr = 80, player = 1, cellx = 1, celly = 1}),
                Unit:new({spr = 80, player = 1, cellx = 2, celly = 2}),
            }

            -- search for the unit
            local unit, idx = Units.at(3, 3, haystack)

            -- assert
            assert.equal(nil, unit)
            assert.equal(nil, idx)
        end)
    end)
end)

require("../src/radius")
require("../src/stage")
require("../src/unit")

local stringx = require 'pl.stringx'

describe("stage", function()
    it("should unserialize stage data", function()
        -- create a `split` function that behaves like the Pico-8 built-in
        local split = function(str, sep)
            local out = stringx.split(str, sep)

            for key, val in pairs(out) do
                if tonumber(val) ~= nil then
                    out[key] = tonumber(val)
                end
            end

            return out
        end

        -- create serialized stage data
        local serialized =
            '1~stage 1@lorem ipsum dolor~1@2~3@4@5@6~1@2@3@4~1@7@8@1@9@10@2@11@12@2@13@14~foo bar~baz bat&'
        serialized = serialized ..
                         '2~stage 2@lorem ipsum dolor~1@2~3@4@5@6~1@2@3@4~1@7@8@1@9@10@2@11@12@2@13@14~foo bar~baz bat'

        -- NB: `Stage.unserialize` returns a table of functions which return
        -- tables that represent a stage. This indirection is (I believe)
        -- necessary in order to facilitate the ability to reload a level.
        -- create functions which return the appropriate payload
        local wantFns = {
            function()
                return {
                    num = 1,
                    intr = {head = "stage 1", body = "lorem ipsum dolor"},
                    camera = {x = 1, y = 2},
                    cell = {x = 3, y = 4, w = 5, h = 6},
                    swap = {{1, 2}, {3, 4}},
                    units = {
                        Unit:new({player = 1, cell = {x = 7, y = 8}}),
                        Unit:new({player = 1, cell = {x = 9, y = 10}}),
                        Unit:new({player = 2, cell = {x = 11, y = 12}}),
                        Unit:new({player = 2, cell = {x = 13, y = 14}}),
                    },
                    talk = {start = {"foo bar"}, clear = {"baz bat"}},
                }
            end,
            function()
                return {
                    num = 2,
                    intr = {head = "stage 2", body = "lorem ipsum dolor"},
                    camera = {x = 1, y = 2},
                    cell = {x = 3, y = 4, w = 5, h = 6},
                    swap = {{1, 2}, {3, 4}},
                    units = {
                        Unit:new({player = 1, cell = {x = 7, y = 8}}),
                        Unit:new({player = 1, cell = {x = 9, y = 10}}),
                        Unit:new({player = 2, cell = {x = 11, y = 12}}),
                        Unit:new({player = 2, cell = {x = 13, y = 14}}),
                    },
                    talk = {start = {"foo bar"}, clear = {"baz bat"}},
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
    end)
end)

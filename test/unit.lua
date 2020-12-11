local luaunit = require('../vendor/luaunit')
require("../src/unit")

function testUnitNew()
    -- initialize a unit
    local u = Unit:new({spr = 1, team = 2, cell = {x = 3, y = 4}})

    -- assert that the unit initialized with the expected values
    luaunit.assertEquals(u.spr, 1)
    luaunit.assertEquals(u.team, 2)
    luaunit.assertEquals(u.cell.x, 3)
    luaunit.assertEquals(u.cell.y, 4)
    luaunit.assertEquals(u.px.x, 24)
    luaunit.assertEquals(u.px.y, 32)
end

function testUnitMove()

end

os.exit(luaunit.LuaUnit.run())

Game = {}

local luaunit = require('../vendor/luaunit')
require("../src/screen")

-- mock a screen
Screens.mock = {name = "mock"}

function testScreenLoad()
    -- load the mock screen
    Screens.load("mock")

    -- assert that the mock screen loaded
    luaunit.assertEquals(Game.screen.name, "mock")
end

os.exit(luaunit.LuaUnit.run())

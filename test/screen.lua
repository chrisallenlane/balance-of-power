-- mock the game global
Game = {}

local luaunit = require('../vendor/luaunit')
require("../src/screen")

-- mock a screen
Game.screens.mock = {name = "mock"}

function testScreenLoad()
    -- load the mock screen
    Game.screens.load("mock")

    -- assert that the mock screen loaded
    luaunit.assertEquals(Game.screen.name, "mock")
end

os.exit(luaunit.LuaUnit.run())

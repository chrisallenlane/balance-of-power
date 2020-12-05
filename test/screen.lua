-- mock the game global
game = {}

local luaunit = require('../vendor/luaunit')
require("../src/screen")

-- mock a screen
game.screens.mock = {name = "mock"}

function testScreenLoad()
    -- load the mock screen
    game.screens.load("mock")

    -- assert that the mock screen loaded
    luaunit.assertEquals(game.screen.name, "mock")
end

os.exit(luaunit.LuaUnit.run())

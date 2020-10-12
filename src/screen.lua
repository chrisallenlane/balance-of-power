game.screen = {}

game.screens = {
    ["title"] = {},
    ["battle"] = {},
    ["defeat"] = {},
    ["victory"] = {},
}

-- loads a screen
function game.screens.load(name)
    game.screen = game.screens[name]
end

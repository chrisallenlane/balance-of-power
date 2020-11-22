game.screen = {}

game.screens = {
    title = {menu = {choices = {"1 player", "2 player", "skirmish"}, sel = 1}},
    battle = {},
    defeat = {},
    victory = {},
}

-- loads a screen
function game.screens.load(name)
    game.screen = game.screens[name]
end

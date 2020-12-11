Game.screen = {}

Game.screens = {
    title = {menu = {choices = {"1 player", "2 player", "skirmish"}, sel = 1}},
    battle = {},
    defeat = {},
    victory = {},
}

-- loads a screen
function Game.screens.load(name)
    Game.screen = Game.screens[name]
end

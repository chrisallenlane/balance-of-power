Game.screen = {}

Screens = {
    title = {menu = {choices = {"1 player", "2 player", "skirmish"}, sel = 1}},
    battle = {},
    defeat = {},
    victory = {},
}

-- loads a screen
function Screens.load(name)
    Game.screen = Screens[name]
end

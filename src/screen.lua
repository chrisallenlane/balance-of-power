Game.screen = {}

Screens = {title = {}, battle = {}, defeat = {}, victory = {}}

-- loads a screen
function Screens.load(name)
    Game.screen = Screens[name]
end

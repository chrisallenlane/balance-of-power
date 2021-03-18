-- track game state
State = {
    -- NB: P2 will be flagged as a CPU in the title screen if appropriate
    players = {
        Player:new({num = 1, cpu = false}),
        Player:new({num = 2, cpu = false}),
    },

    -- the game camera
    camera = Camera:new(),

    -- the current screen
    screen = Screens.title,

    -- the current menu
    menu = nil,

    -- the current stage
    stage = {},

    -- the game cursor
    -- TODO: deprecate this
    cursor = Cursor,
}

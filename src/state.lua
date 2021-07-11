-- track game state
State = {
  -- the current frame number
  frame = 0,

  -- the player whose turn is now
  player = {},

  -- both players
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

  -- the talk screen
  talk = Talk:new(),

  -- animation sequence queue
  seq = Seq:new(),

  -- the current stage
  stage = {},

  -- saved progress stage number
  savedStage = 0,

  -- suppress talk dialog
  optNoTalk = false,
}

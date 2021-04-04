Stage = {}

function Stage:new(stage)
    -- return a function that initializes the stage
    setmetatable(stage, self)
    self.__index = self
    return stage
end

-- load the specified stage
function Stage.load(num, stages, screens, state)
    -- load the specified stage
    -- NB: this indirection is necessary in order to facilitate the "reset map"
    -- function. Each stage must be initialized atop a new literal object in
    -- order to create a truly "new" stage (ie, one that is not a shallow
    -- copy).
    state.stage = Stage:new(stages[num]())

    -- make it player 1's turn
    state.player = state.players[1]

    -- set each player's cursor to rest on their first unit
    for i = 1, 2 do
        local unit = Units.first(i, state.stage.units)
        local x, y = unit.cell.x, unit.cell.y
        state.players[i].cursor:warp(x, y)
        state.players[i].cursor.vis = true
    end

    -- reset the camera position
    state.camera:warp(state.stage.camera.x, state.stage.camera.y)
    state.screen = screens.intr

    -- play the opening dialogue if provided (for single-player games only)
    if state.stage.talk and state.stage.talk.start and state.players[2].cpu then
        Seq:enqueue({
            Anim.delay(90),
            function()
                state.talk:say(state.stage.talk.start)
                return true
            end,
        })
    end
end

-- advance to the next stage
function Stage:advance(stages, screens, state)
    if self.num < #stages then
        Stage.load(self.num + 1, stages, screens, state)
    else
        state.screen = screens.victory
    end
end

-- return true if the stage has been cleared
function Stage.clear(state)
    -- get the number of units remaining for each player
    local p1, p2 = Units.remain(state.stage.units)

    -- player 1 is victorious
    if p2 == 0 then
        return true, 1

        -- player 2 is victorious
    elseif p1 == 0 then
        return true, 2

        -- the match is ungoing
    else
        return false, nil
    end
end

-- draw the current stage
function Stage.draw(state)
    local s = state.stage

    -- implement any specified palette swaps for the stage
    if s.swap then for i = 1, #s.swap do pal(s.swap[i][1], s.swap[i][2]) end end

    -- draw the map
    map(s.cell.x, s.cell.y, 0, 0, s.cell.w, s.cell.h)

    -- reset palette swaps
    pal()
end

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
                state.talk:say(state.stage.talk.start, state)
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

-- unserialize stage data
function Stage.unserialize(serialized, spl, ad)
    -- NB: the unit tests need this
    spl = spl or split
    ad = ad or add

    -- initialize a table of stage constructor functions
    local stages = {}

    -- stage rows are separated by a `&`
    for _, stage in ipairs(spl(serialized, '&')) do
        -- fields are separated by a `~`
        local fields = spl(stage, '~')

        -- unpack the "easy" object properties
        local obj = {
            num = fields[1],
            intr = Stage.unpack("head,body", fields[2], spl),
            camera = Stage.unpack("x,y", fields[3], spl),
            cell = Stage.unpack("x,y,w,h", fields[4], spl),
            swap = {},
            units = {},
            talk = {start = spl(fields[7], "@"), clear = spl(fields[8], "@")},
        }

        -- parse out swap data
        local sd = spl(fields[5], "@")
        for i = 1, #sd, 2 do ad(obj.swap, {sd[i], sd[i + 1]}) end

        -- parse out unit data
        local ud = spl(fields[6], "@")
        for i = 1, #ud, 3 do
            ad(obj.units, Unit:new({
                player = ud[i],
                cell = {x = ud[i + 1], y = ud[i + 2]},
            }))
        end

        -- create a constructor that returns the object
        ad(stages, function()
            return obj
        end)
    end

    return stages
end

function Stage.unpack(keystr, field, spl)
    -- NB: the unit tests need this
    spl = spl or split

    -- NB: specify the comma separator, or the unit-tests will fail
    local keys, obj = spl(keystr, ","), {}

    for i, val in ipairs(spl(field, "@")) do obj[keys[i]] = val end

    return obj
end

Stage = {}

function Stage:new(stage)
    -- return a function that initializes the stage
    setmetatable(stage, self)
    self.__index = self
    return stage
end

-- load the specified stage
function Stage.load(num, stages, screens, state)
    -- XXX: is it necessary to free memory from the prior stage here?

    -- state.savedStage = num
    dset(0, num)

    -- load the specified stage
    -- NB: this indirection is necessary in order to facilitate the "reset map"
    -- function. Each stage must be initialized atop a new literal object in
    -- order to create a truly "new" stage (ie, one that is not a shallow
    -- copy).
    state.stage = Stage:new(stages[num]())

    -- make it player 1's turn
    state.player = state.players[1]

    -- get the units on each team
    -- NB: `friends` will always be player 1 units here (see above)
    local friends, foes = Units.teams(state)
    local team = {friends, foes}

    -- set each player's cursor to rest on their first unit
    for i = 1, 2 do
        local unit = team[i][1]
        local x, y = unit.cellx, unit.celly
        state.players[i].cursor.cellx = x
        state.players[i].cursor.celly = y
        state.players[i].cursor.vis = true
    end

    -- reset the camera position
    state.camera:warp(state.stage.camera.cellx, state.stage.camera.celly)
    state.screen = screens.intr

    -- clear enqueued animation sequences
    Seq:clear()

    -- hide the info bar
    Info:set("", "", {})

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
    local friends, foes = Units.teams(state)

    if #friends == 0 then
        return true, state.player.num == 1 and 2 or 1
    elseif #foes == 0 then
        return true, state.player.num
    else
        return false, nil
    end
end

-- draw the current stage
function Stage.draw(state)
    local s = state.stage

    -- implement any specified palette swaps for the stage
    Stage.palswap(state)

    -- draw the map
    map(s.cellx, s.celly, 0, 0, s.cellw, s.cellh)

    -- reset palette swaps
    pal()
end

function Stage.palswap(state)
    local s = state.stage
    if s.swap then for i = 1, #s.swap do pal(s.swap[i][1], s.swap[i][2]) end end
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
        -- KLUDGE: should change the serialization format and remove this
        local cell = Stage.unpack("x,y,w,h", fields[4], spl)
        local cam = Stage.unpack("x,y", fields[3], spl)
        local obj = {
            num = fields[1],
            intr = Stage.unpack("head,body", fields[2], spl),
            camera = {cellx = cam.x, celly = cam.y},
            cellh = cell.h,
            cellw = cell.w,
            cellx = cell.x,
            celly = cell.y,
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
                id = #obj.units + 1,
                player = ud[i],
                cellx = ud[i + 1],
                celly = ud[i + 2],
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

CPU = {battle = {}}

-- NB: this is a stub
-- TODO: DRY out significant repetition here
function CPU.battle.update(state)
    Info:set("", "")

    -- shorthand
    local player, stage = state.player, state.stage

    -- split units into teams
    local friends, foes = Units.teams(state)

    -- identify friendly units that are within attack range of enemy units
    local aggressors = {}
    for _, friend in ipairs(friends) do
        for _, foe in ipairs(foes) do
            -- flag the aggressor
            if friend.radius:contains('dng', foe.cellx, foe.celly) and
                friend.stat.atk >= 1 then add(aggressors, friend) end
        end
    end

    -- select CPU unit at random
    local unit = rnd(#aggressors >= 1 and aggressors or friends)

    -- calculate the unit's radius
    unit.radius:update(unit, stage, 2)

    -- TODO: this is inefficient. We can determine above which unit the enemy
    -- is in contact with.
    -- iterate over the enemy (player) units
    local target = false
    for _, foe in ipairs(foes) do
        -- determine if `foe` is within our unit's danger radius
        if unit.radius:contains('dng', foe.cellx, foe.celly) then
            -- if we've found a target, break out of the loop
            target = foe
            break
        end
    end

    -- if we've found a target, move and attack
    if target then
        -- calculate a new radius (of radius rng+1) centered on the foe's
        -- position
        local targetRadius = Radius:new()
        targetRadius:atk(target.cellx, target.celly, unit.stat.rng + 1,
                         state.stage, 2)

        -- identify the subset of cells in the intersection of the unit and
        -- target radii
        local intersection = targetRadius:intersect('atk', 'mov', unit.radius)

        -- select a random cell within intersection
        local cell = intersection:rand('atk', state)

        -- move the unit
        unit:move(cell.x, cell.y)

        -- record the CPU's (fake) cursor location
        player.cursor.cellx, player.cursor.celly = cell.x, cell.y

        -- enqueue the animations
        Seq:enqueue({
            Anim.delay(30),
            Anim.trans(unit, cell.x, cell.y),
            Anim.delay(15),
        })

        -- attack the target and enqeue the resultant animations
        Seq:enqueue(Player.attack(unit, target, 'atk', state))

        -- otherwise, make a valid random move
    else
        -- select a random cell within the movement radius
        local cell = unit.radius:rand('mov', state)
        if cell then
            -- move the unit
            unit:move(cell.x, cell.y)

            -- unqueue the animations
            Seq:enqueue({Anim.delay(30), Anim.trans(unit, cell.x, cell.y)})

            -- record the CPU's (fake) cursor location
            player.cursor.cellx, player.cursor.celly = cell.x, cell.y
        end

        -- end the CPU turn
        player:turnEnd(state)
    end
end

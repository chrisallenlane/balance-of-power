Units = {delay = 0}

-- At returns the unit at the specified coordinates, or false if none is there
function Units.at(x, y, units)
    for idx, unit in pairs(units) do
        if unit.cell.x == x and unit.cell.y == y then return unit, idx end
    end

    return nil, nil
end

-- Returns the first unit on `player`'s team team
function Units.first(player, units)
    for _, unit in pairs(units) do
        if unit.player == player then return unit end
    end
end

-- draw the units
function Units.draw(state)
    for _, unit in pairs(state.stage.units) do
        -- use palette swapping to reduce the number of sprites required
        pal()

        -- player 1, inactive
        if unit.player == 1 and not unit.active then
            pal(12, 13)

        elseif unit.player == 2 then
            -- player 2, active
            if unit.active then
                pal(12, 8)
                pal(1, 2)

                -- player 2, inactive
            else
                pal(12, 2)
                pal(1, 5)
            end
        end

        spr(0, unit.px.x, unit.px.y)
    end

    pal()
end

-- Remain returns the number of units remaining for each player
function Units.remain(units)
    -- track the number of units remaining for each player
    local p1, p2 = 0, 0

    -- iterate over all units on the stage
    for _, unit in pairs(units) do
        if unit.player == 1 then
            p1 = p1 + 1
        else
            p2 = p2 + 1
        end
    end

    return p1, p2
end

-- repairs units that are placed within a city
function Units.repair(state)
    -- iterate over each unit that belongs to the player
    for _, unit in ipairs(state.stage.units) do
        -- filter to only units belonging to the current player
        if unit.player == state.player.num then
            -- get the tile beneath the unit
            local tile = mget(unit.cell.x + state.stage.cell.x,
                              unit.cell.y + state.stage.cell.y)

            -- repair the unit if it's in a city
            if tile == 112 then
                if unit.pwr < 10 then
                    -- increment the unit power
                    unit.pwr = unit.pwr + 1

                    -- play the repair animation
                    state.camera:focus(unit.cell.x, unit.cell.y, state)
                    Seq:enqueue({
                        Anim.delay(30),
                        Anim.trans(state.camera, unit.cell.x, unit.cell.y),
                        Anim.repair(unit, state),
                    })
                end
            end
        end
    end
end

-- deactivate all units
function Units.deactivate(units, player)
    for _, unit in pairs(units) do
        if unit.player == player then unit:deactivate() end
    end
end

-- refresh all units
function Units.refresh(units)
    for _, unit in pairs(units) do
        unit.active, unit.act.atk, unit.act.mov = true, false, false
    end
end

-- Die kills a unit
function Units.die(idx, units)
    deli(units, idx)
end

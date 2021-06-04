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

-- Group the units into a table of "friends" and "foes" (relative) to the
-- current player
function Units.teams(state)
    local friends, foes = {}, {}

    -- iterate over and sort the units
    for _, u in pairs(state.stage.units) do
        if u.player == state.player.num then
            add(friends, u)
        else
            add(foes, u)
        end
    end

    return friends, foes
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

-- repairs units that are placed within a city
function Units.repair(state)
    -- iterate over each unit that belongs to the player
    for _, unit in ipairs(state.stage.units) do
        -- repair the unit if applicable
        if unit.player == state.player.num and
            Cell.repair(unit.cell.x, unit.cell.y, state.stage) >= 1 and unit.pwr <
            10 then
            -- increment the unit power
            unit.pwr = unit.pwr + 1

            -- play the repair animation
            Seq:enqueue({
                Anim.delay(30),
                function()
                    state.camera:focus(unit.cell.x, unit.cell.y, state)
                    return true
                end,
                Anim.trans(state.camera, state.camera.cell.x,
                           state.camera.cell.y),
                Anim.repair(unit, state),
            })
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
function Units.die(id, units)
    for i, unit in ipairs(units) do
        if unit.id == id then
            deli(units, i)
            break
        end
    end
end

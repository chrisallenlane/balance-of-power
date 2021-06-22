Units = {delay = 0}

-- At returns the unit at the specified coordinates, or false if none is there
function Units.at(x, y, units)
    for idx, unit in pairs(units) do
        if unit.cellx == x and unit.celly == y then return unit, idx end
    end

    return nil, nil
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

        unit:draw()
    end

    pal()
end

-- repairs units that are placed within a city
function Units.repair(state)
    -- iterate over each unit that belongs to the player
    for _, unit in ipairs(state.stage.units) do
        -- repair value of the cell on which the unit rests
        local repair = Cell.datum(unit.cellx, unit.celly, 'repair', state)

        -- if the unit rests on a repair cell, repair the unit
        if unit.player == state.player.num and repair >= 1 and unit.pwr < 10 then
            -- play the repair animation, and then heal the unit
            Seq:enqueue({
                Anim.delay(30),
                function()
                    state.camera:focus(unit.cellx, unit.celly, state)
                end,
                Anim.trans(state.camera, state.camera.cellx, state.camera.celly),
                Anim.repair(unit, state),
                function()
                    unit:repair()
                end,
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
        unit.active, unit.attacked, unit.moved, unit.radius.vis, unit.step =
            true, false, false, false, 0.001
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

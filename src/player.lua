Player = {battle = {}}

-- define the constructor
function Player:new(p)
    setmetatable(p, self)
    self.__index = self

    -- each player owns a cursor
    p.cursor = Cursor:new()

    return p
end

function Player.battle.update(state, inputs)
    -- reclaim tokens
    local yes, no = inputs.yes, inputs.no
    local cur, player, stage = state.player.cursor, state.player, state.stage

    -- determine whether a unit is beneath the cursor
    local unit, idx = Units.at(cur.cell.x, cur.cell.y, stage.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- is the unit a friend?
        local friend = unit.player == player.num

        -- ... and the unit is a friend...
        if friend then

            --- ...and is active but not selected, then select it
            if not cur:selected(unit) and unit.active then
                Info:set("select", "", unit)
                if yes:once() then
                    cur.unit.sel = unit
                    -- hide all other friendly unit radii
                    for _, u in pairs(state.stage.units) do
                        if u.player == player.num then
                            u.radius.vis = false
                        end
                    end

                    unit.radius:update(unit, stage, player.num)
                    return
                end

                -- ... and is selected ...
            elseif cur:selected() then

                -- ... and has not acted, then open the balance menu
                if not unit:acted() and unit.active then
                    Info:set("balance", "unselect", unit)
                    if yes:once() then
                        Menus.Balance:open(cur.unit.sel, idx, state)
                        return
                    end

                    -- ... and has moved but not attack, allow an undo move
                elseif unit:moved() and not unit:attacked() then
                    Info:set("end turn", "cancel", unit)
                    if yes:once() then
                        Menus.TurnEnd:open(state)
                        return
                    end
                    if no:once() then
                        cur.unit.sel.radius.vis = false
                        cur.unit.sel:unmove(state)
                        Seq:enqueue({
                            Anim.trans(cur.unit.sel, cur.unit.sel.cell.x,
                                       cur.unit.sel.cell.y),
                            function()
                                cur.unit.sel = nil
                                return true
                            end,
                        })
                        return
                    end
                end
            end

            -- ... and the unit is not a friend ...
        elseif not friend then

            -- ... and if no friendly unit has been selected ...
            if not cur:selected() then

                -- ... and the enemy's radii are invisible, then show the radii
                if unit.radius.vis == false then
                    Info:set("view radii", "", unit)
                    if yes:once() then
                        -- draw the radii for the enemy player
                        unit.radius:update(unit, stage,
                                           player.num == 2 and 1 or 2)
                        return
                    end

                    -- ... and the enemy's radii are visible, then hide the radii
                elseif unit.radius.vis == true then
                    Info:set("hide radii", "", unit)
                    if yes:once() or no:once() then
                        unit.radius.vis = false
                        return
                    end
                end

                -- ... and if a friendly unit has been selected, and is capable
                -- of attacking, then attack the enemy unit
            elseif cur:selected() and not cur.unit.sel:attacked() and
                cur.unit.sel.active and
                cur.unit.sel.radius:contains('atk', unit.cell.x, unit.cell.y) then
                Info:set("attack", "unselect", unit)
                if yes:once() then
                    Menus.Target:open(unit, state)
                    return
                end
            end
        end

        -- if there is no unit is beneath the cursor...
    elseif not unit then

        -- ... but an active, friendly unit has been selected, then move the
        -- friendly unit
        if cur:selected() and cur.unit.sel.active and not cur.unit.sel:moved() and
            Cell.open(cur.cell.x, cur.cell.y, stage) and
            cur.unit.sel.radius:contains('mov', cur.cell.x, cur.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                cur.unit.sel:move(cur.cell.x, cur.cell.y)
                cur.unit.sel.radius.vis = false

                -- deactivate all *other* units belonging to the player
                Units.deactivate(stage.units, player.num)
                cur.unit.sel:activate()

                -- enqueue animations
                Seq:enqueue({Anim.trans(cur.unit.sel, cur.cell.x, cur.cell.y)})

                -- end the player's turn if the unit is exhausted
                if cur.unit.sel:attacked() or cur.unit.sel.stat.atk == 0 or
                    cur.unit.sel.stat.rng == 0 then
                    player:turnEnd(state)
                    -- otherwise, show the attack radius
                else
                    cur.unit.sel.radius:update(cur.unit.sel, stage, player.num)
                end
                return
            end

            -- ... but no unit has been selected, then show the "end turn" menu
        elseif not cur:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then
                Menus.TurnEnd:open(state)
                return
            end
        end
    end

    -- "Z"
    if no:once() then
        -- if a unit is selected, unselect it
        if cur:selected() then
            -- unselect the unit if it is ours
            cur.unit.sel.radius.vis = false
            cur.unit.sel = nil
            -- show the "end turn" menu
        else
            Menus.TurnEnd:open(state)
        end
        return
    end
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- change the player turn
function Player:turnEnd(state)
    local cam = state.camera

    -- hide radii
    Radius.clearAll(state.stage.units)

    -- unselect the unit
    state.player.cursor.unit.sel = nil

    -- refresh all units
    Units.refresh(state.stage.units)

    -- swap the current player
    state.player = self.num == 1 and state.players[2] or state.players[1]

    -- repair units (that belong to the new player) that are in a city
    Units.repair(state)

    -- center the screen on the specified coordinates
    local curcell = state.player.cursor.cell
    Seq:enqueue({
        Anim.delay(30),
        function()
            cam:focus(curcell.x, curcell.y, state)
            return true
        end,
        Anim.trans(cam, cam.cell.x, cam.cell.y),
    })
end

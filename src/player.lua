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
    -- for brevity
    local yes = inputs.yes
    local no = inputs.no
    local cur = state.player.cursor

    -- update the cursor position
    cur:update(state.stage, inputs)

    -- determine whether a unit is beneath the cursor
    local unit, idx = Units.at(cur.cell.x, cur.cell.y, state.stage.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- select friendly unit:
        if unit:friend(state.player.num) and not cur:selected(unit) and
            unit.active then
            Info:set("select", "", unit)

            if yes:once() then
                cur.sel = unit
                Radius:update(unit, state.stage, state.player.num)
            end

            -- open friendly balance menu:
        elseif unit:friend(state.player.num) and cur:selected(unit) and
            not unit:acted() then
            Info:set("balance", "unselect", unit)

            if yes:once() then
                Menus.Balance:open(cur.sel, idx, state)
            end

            -- open the "turn end" menu if the unit has already
            -- taken an action
        elseif unit:friend(state.player.num) and cur:selected(unit) and
            unit:acted() then
            Info:set("end turn", "unselect", unit)

            if yes:once() then Menus.TurnEnd:open(state) end

            -- view enemy radii:
        elseif unit:foe(state.player.num) and not cur:selected() then
            Info:set("view radii", "", unit)

            if yes:once() then
                -- get the enemy player number
                local enemy = 2
                if state.player.num == 2 then enemy = 1 end

                -- draw the radii for the enemy player
                Radius:update(unit, state.stage, enemy)
            end

            -- attack enemy:
        elseif unit:foe(state.player.num) and cur:selected() and
            not cur.sel:attacked() and cur.sel.active and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            Info:set("attack", "unselect", unit)

            if yes:once() then Menus.Target:open(unit, idx, state) end
        end

        -- if no unit is beneath the cursor...
    elseif not unit then
        -- move friendly unit:
        if cur:selected() and cur.sel.active and not cur.sel:moved() and
            Cell.open(cur.cell.x, cur.cell.y, state.stage) and
            Radius:contains('mov', cur.cell.x, cur.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                cur.sel:move(cur.cell.x, cur.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(state.stage.units, state.player.num)
                cur.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if cur.sel:attacked() or cur.sel.stat.atk == 0 or
                    cur.sel.stat.rng == 0 then
                    state.player:turn_end(state)
                    -- otherwise, show the attack radius
                else
                    Radius:update(cur.sel, state.stage, state.player.num)
                end
            end

            -- show the "end turn" menu
        elseif not cur:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then Menus.TurnEnd:open(state) end
        end
    end

    -- "Z"
    if no:once() then
        -- hide radii
        if Radius.vis then
            -- unselect the unit if it is ours
            if cur:selected() then cur.sel = nil end
            Radius:clear()
            -- show the "end turn" menu
        else
            Menus.TurnEnd:open(state)
        end
    end

    -- draw an AStar trail showing the unit movement path
    if cur:selected() and Radius:contains('mov', cur.cell.x, cur.cell.y) then
        local src = Cell:new(cur.sel.cell.x, cur.sel.cell.y, state.stage.cell.w)
        local dst = Cell:new(cur.cell.x, cur.cell.y, state.stage.cell.w)
        cur.path = cur.astar:search(src, dst, state.stage)
    else
        cur.path = {}
    end
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- change the player turn
function Player:turn_end(state)
    local cur = state.player.cursor

    -- unselect the unit
    cur.sel = nil

    -- hide radii
    -- TODO: move elsewhere
    Radius:clear()

    -- refresh all units
    Units.refresh(state.stage.units)

    -- end the turn
    if self.num == 1 then
        state.player = state.players[2]
    else
        state.player = state.players[1]
    end

    -- center the screen on the specified coordinates
    state.camera:focus(cur.cell.x, cur.cell.y, state.stage.cell.w,
                       state.stage.cell.h, 4)
end

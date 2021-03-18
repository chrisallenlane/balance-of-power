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

    -- update the cursor position
    --self.cursor:update(state.stage, inputs)
    state.player.cursor:update(state.stage, inputs)

    -- determine whether a unit is beneath the cursor
    --local unit, idx = Units.at(self.cursor.cell.x, self.cursor.cell.y, state.stage.units)
    local unit, idx = Units.at(state.player.cursor.cell.x, state.player.cursor.cell.y, state.stage.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- select friendly unit:
        if unit:friend(state.player.num) and not state.player.cursor:selected(unit) and
            unit.active then
            Info:set("select", "", unit)

            if yes:once() then
                state.player.cursor.sel = unit
                Radius:update(unit, state.stage, state.player.num)
            end

            -- open friendly balance menu:
        elseif unit:friend(state.player.num) and state.player.cursor:selected(unit) and
            not unit:acted() then
            Info:set("balance", "unselect", unit)

            if yes:once() then
                Menus.Balance:open(state.player.cursor.sel, idx, state)
            end

            -- open the "turn end" menu if the unit has already
            -- taken an action
        elseif unit:friend(state.player.num) and state.player.cursor:selected(unit) and
            unit:acted() then
            Info:set("end turn", "unselect", unit)

            if yes:once() then Menus.TurnEnd:open(state) end

            -- view enemy radii:
        elseif unit:foe(state.player.num) and not state.player.cursor:selected() then
            Info:set("view radii", "", unit)

            if yes:once() then
                -- get the enemy player number
                local enemy = 2
                if state.player.num == 2 then enemy = 1 end

                -- draw the radii for the enemy player
                Radius:update(unit, state.stage, enemy)
            end

            -- attack enemy:
        elseif unit:foe(state.player.num) and state.player.cursor:selected() and
            not state.player.cursor.sel:attacked() and state.player.cursor.sel.active and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            Info:set("attack", "unselect", unit)

            if yes:once() then Menus.Target:open(unit, idx, state) end
        end

        -- if no unit is beneath the cursor...
    elseif not unit then
        -- move friendly unit:
        if state.player.cursor:selected() and state.player.cursor.sel.active and
            not state.player.cursor.sel:moved() and
            Cell.open(state.player.cursor.cell.x, state.player.cursor.cell.y, state.stage) and
            Radius:contains('mov', state.player.cursor.cell.x, state.player.cursor.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                state.player.cursor.sel:move(state.player.cursor.cell.x, state.player.cursor.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(state.stage.units, state.player.num)
                state.player.cursor.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if state.player.cursor.sel:attacked() or state.player.cursor.sel.stat.atk == 0 or
                    state.player.cursor.sel.stat.rng == 0 then
                    state.player:turn_end(state)
                    -- otherwise, show the attack radius
                else
                    Radius:update(state.player.cursor.sel, state.stage,
                                  state.player.num)
                end
            end

            -- show the "end turn" menu
        elseif not state.player.cursor:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then Menus.TurnEnd:open(state) end
        end
    end

    -- "Z"
    if no:once() then
        -- hide radii
        if Radius.vis then
            -- unselect the unit if it is ours
            if state.player.cursor:selected() then state.player.cursor.sel = nil end
            Radius:clear()
            -- show the "end turn" menu
        else
            Menus.TurnEnd:open(state)
        end
    end

    -- draw an AStar trail showing the unit movement path
    if state.player.cursor:selected() and
        Radius:contains('mov', state.player.cursor.cell.x, state.player.cursor.cell.y) then
        local src = Cell:new(state.player.cursor.sel.cell.x, state.player.cursor.sel.cell.y,
                             state.stage.cell.w)
        local dst = Cell:new(state.player.cursor.cell.x, state.player.cursor.cell.y,
                             state.stage.cell.w)
        state.player.cursor.path = state.player.cursor.astar:search(src, dst, state.stage)
    else
        state.player.cursor.path = {}
    end
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- change the player turn
function Player:turn_end(state)
    -- record the current player's cursor position
    if state.player.cursor.sel then
        state.player.cursor.last[self.num] = {
            x = state.player.cursor.sel.cell.x,
            y = state.player.cursor.sel.cell.y,
        }
    else
        state.player.cursor.last[self.num] = {
            x = state.player.cursor.cell.x,
            y = state.player.cursor.cell.y,
        }
    end

    -- unselect the unit
    state.player.cursor.sel = nil

    -- hide radii
    Radius:clear()

    -- refresh all units
    Units.refresh(state.stage.units)

    -- end the turn
    -- XXX: this is bad
    local enemy
    if self.num == 1 then
        enemy = 2
        state.player = state.players[2]
    else
        enemy = 1
        state.player = state.players[1]
    end

    -- TODO: refactor into Cursor save/load or something?
    -- load the next player's cursor
    if state.player.cursor.last[enemy].x == nil or state.player.cursor.last[enemy].y == nil then
        local unit = Units.first(enemy, state.stage.units)
        state.player.cursor.cell.x = unit.cell.x
        state.player.cursor.cell.y = unit.cell.y
    else
        state.player.cursor.cell.x = state.player.cursor.last[enemy].x
        state.player.cursor.cell.y = state.player.cursor.last[enemy].y
    end

    -- center the screen on the specified coordinates
    state.camera:focus(state.player.cursor.cell.x, state.player.cursor.cell.y,
                       state.stage.cell.w, state.stage.cell.h, 4)
end

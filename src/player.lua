Player = {battle = {}}

-- define the constructor
function Player:new(p)
    setmetatable(p, self)
    self.__index = self
    return p
end

function Player.battle.update(state, inputs)
    -- for brevity
    local yes = inputs.yes
    local no = inputs.no

    -- update the cursor position
    state.cursor:update(state.stage, inputs)

    -- determine whether a unit is beneath the cursor
    local unit, idx = Units.at(state.cursor.cell.x, state.cursor.cell.y,
                               state.stage.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- select friendly unit:
        if unit:friend(state.player.num) and not state.cursor:selected(unit) and
            unit.active then
            Info:set("select", "", unit)

            if yes:once() then
                state.cursor.sel = unit
                Radius:update(unit, state.stage, state.player.num)
            end

            -- open friendly balance menu:
        elseif unit:friend(state.player.num) and state.cursor:selected(unit) and
            not unit:acted() then
            Info:set("balance", "unselect", unit)

            if yes:once() then
                Menus.Balance:open(state.cursor.sel, idx, state)
            end

            -- open the "turn end" menu if the unit has already
            -- taken an action
        elseif unit:friend(state.player.num) and state.cursor:selected(unit) and
            unit:acted() then
            Info:set("end turn", "unselect", unit)

            if yes:once() then Menus.TurnEnd:open(state) end

            -- view enemy radii:
        elseif unit:foe(state.player.num) and not state.cursor:selected() then
            Info:set("view radii", "", unit)

            if yes:once() then
                -- get the enemy player number
                local enemy = 2
                if state.player.num == 2 then enemy = 1 end

                -- draw the radii for the enemy player
                Radius:update(unit, state.stage, enemy)
            end

            -- attack enemy:
        elseif unit:foe(state.player.num) and state.cursor:selected() and
            not state.cursor.sel:attacked() and state.cursor.sel.active and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            Info:set("attack", "unselect", unit)

            if yes:once() then Menus.Target:open(unit, idx, state) end
        end

        -- if no unit is beneath the cursor...
    elseif not unit then
        -- move friendly unit:
        if state.cursor:selected() and state.cursor.sel.active and
            not state.cursor.sel:moved() and
            Cell.open(state.cursor.cell.x, state.cursor.cell.y, state.stage) and
            Radius:contains('mov', state.cursor.cell.x, state.cursor.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                state.cursor.sel:move(state.cursor.cell.x, state.cursor.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(state.stage.units, state.player.num)
                state.cursor.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if state.cursor.sel:attacked() or state.cursor.sel.stat.atk == 0 or
                    state.cursor.sel.stat.rng == 0 then
                    state.player:turn_end(state)
                    -- otherwise, show the attack radius
                else
                    Radius:update(state.cursor.sel, state.stage,
                                  state.player.num)
                end
            end

            -- show the "end turn" menu
        elseif not state.cursor:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then Menus.TurnEnd:open(state) end
        end
    end

    -- "Z"
    if no:once() then
        -- hide radii
        if Radius.vis then
            -- unselect the unit if it is ours
            if state.cursor:selected() then state.cursor.sel = nil end
            Radius:clear()
            -- show the "end turn" menu
        else
            Menus.TurnEnd:open(state)
        end
    end

    -- draw an AStar trail showing the unit movement path
    if state.cursor:selected() and
        Radius:contains('mov', state.cursor.cell.x, state.cursor.cell.y) then
        local src = Cell:new(state.cursor.sel.cell.x, state.cursor.sel.cell.y,
                             state.stage.cell.w)
        local dst = Cell:new(state.cursor.cell.x, state.cursor.cell.y,
                             state.stage.cell.w)
        state.cursor.path = state.cursor.astar:search(src, dst, state.stage)
    else
        state.cursor.path = {}
    end
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- change the player turn
function Player:turn_end(state)
    -- record the current player's cursor position
    if state.cursor.sel then
        state.cursor.last[self.num] = {
            x = state.cursor.sel.cell.x,
            y = state.cursor.sel.cell.y,
        }
    else
        state.cursor.last[self.num] = {
            x = state.cursor.cell.x,
            y = state.cursor.cell.y,
        }
    end

    -- unselect the unit
    state.cursor.sel = nil

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
    if state.cursor.last[enemy].x == nil or state.cursor.last[enemy].y == nil then
        local unit = Units.first(enemy, state.stage.units)
        state.cursor.cell.x = unit.cell.x
        state.cursor.cell.y = unit.cell.y
    else
        state.cursor.cell.x = state.cursor.last[enemy].x
        state.cursor.cell.y = state.cursor.last[enemy].y
    end

    -- center the screen on the specified coordinates
    state.camera:focus(state.cursor.cell.x, state.cursor.cell.y,
                       state.stage.cell.w, state.stage.cell.h, 4)
end

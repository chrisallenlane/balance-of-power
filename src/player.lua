Player = {battle = {}, num = 1}

-- define the constructor
function Player:new(p)
    setmetatable(p, self)
    self.__index = self
    return p
end

function Player.battle.update(inputs)
    -- for brevity
    local yes = inputs.yes
    local no = inputs.no

    -- update the cursor position
    Cursor:update(Map.current, inputs)

    -- determine whether a unit is beneath the cursor
    local unit, idx = Units.at(Cursor.cell.x, Cursor.cell.y, Map.current.units)

    -- if there is a unit beneath the cursor...
    if unit then
        -- select friendly unit:
        if unit:friend(Player.num) and not Cursor:selected(unit) and unit.active then
            Info:set("select", "", unit)

            if yes:once() then
                Cursor.sel = unit
                Radius:update(unit, Map.current, Player.num)
            end

            -- open friendly balance menu:
        elseif unit:friend(Player.num) and Cursor:selected(unit) and
            not unit:acted() then
            Info:set("balance", "unselect", unit)

            if yes:once() then MenuBalance:open(Cursor.sel, idx) end

            -- open the "turn end" menu if the unit has already
            -- taken an action
        elseif unit:friend(Player.num) and Cursor:selected(unit) and
            unit:acted() then
            Info:set("end turn", "unselect", unit)

            if yes:once() then MenuTurnEnd:open() end

            -- view enemy radii:
        elseif unit:foe(Player.num) and not Cursor:selected() then
            Info:set("view radii", "", unit)

            if yes:once() then
                -- get the enemy player number
                local enemy = 2
                if Player.num == 2 then enemy = 1 end

                -- draw the radii for the enemy player
                Radius:update(unit, Map.current, enemy)
            end

            -- attack enemy:
        elseif unit:foe(Player.num) and Cursor:selected() and
            not Cursor.sel:attacked() and Cursor.sel.active and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            Info:set("attack", "unselect", unit)

            if yes:once() then MenuTarget:open(unit, idx) end
        end

        -- if no unit is beneath the cursor...
    elseif not unit then
        -- move friendly unit:
        if Cursor:selected() and Cursor.sel.active and not Cursor.sel:moved() and
            Cell.open(Cursor.cell.x, Cursor.cell.y, Map.current) and
            Radius:contains('mov', Cursor.cell.x, Cursor.cell.y) then
            Info:set("move", "unselect")

            if yes:once() then
                -- move the unit
                Cursor.sel:move(Cursor.cell.x, Cursor.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(Map.current.units, Player.num)
                Cursor.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if Cursor.sel:attacked() or Cursor.sel.stat.atk == 0 or
                    Cursor.sel.stat.rng == 0 then
                    Player:turn_end()
                    -- otherwise, show the attack radius
                else
                    Radius:update(Cursor.sel, Map.current, Player.num)
                end
            end

            -- show the "end turn" menu
        elseif not Cursor:selected() then
            Info:set("end turn", "end turn")
            if yes:once() then MenuTurnEnd:open() end
        end
    end

    -- "Z"
    if no:once() then
        -- hide radii
        if Radius.vis then
            -- unselect the unit if it is ours
            if Cursor:selected() then Cursor.sel = nil end
            Radius:clear()
            -- show the "end turn" menu
        else
            MenuTurnEnd:open()
        end
    end

    -- draw an AStar trail showing the unit movement path
    if Cursor:selected() and
        Radius:contains('mov', Cursor.cell.x, Cursor.cell.y) then
        local src = Cell:new(Cursor.sel.cell.x, Cursor.sel.cell.y,
                             Map.current.cell.w)
        local dst = Cell:new(Cursor.cell.x, Cursor.cell.y, Map.current.cell.w)
        Cursor.path = Cursor.astar:search(src, dst, Map.current)
    else
        Cursor.path = {}
    end
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- TODO: move this into player?
-- change the player turn
function Player:turn_end()
    -- record the current player's cursor position
    if Cursor.sel then
        Cursor.last[self.num] = {x = Cursor.sel.cell.x, y = Cursor.sel.cell.y}
    else
        Cursor.last[self.num] = {x = Cursor.cell.x, y = Cursor.cell.y}
    end

    -- unselect the unit
    Cursor.sel = nil

    -- hide radii
    Radius:clear()

    -- end the turn
    if self.num == 1 then
        self.num = 2
    else
        self.num = 1
    end

    -- refresh all units
    Units.refresh(Map.current.units)

    -- TODO: refactor into Cursor save/load or something?
    -- load the next player's cursor
    if Cursor.last[self.num].x == nil or Cursor.last[self.num].y == nil then
        local unit = Units.first(self.num, Map.current.units)
        Cursor.cell.x = unit.cell.x
        Cursor.cell.y = unit.cell.y
    else
        Cursor.cell.x = Cursor.last[self.num].x
        Cursor.cell.y = Cursor.last[self.num].y
    end

    -- center the screen on the specified coordinates
    State.camera:focus(Cursor.cell.x, Cursor.cell.y, Map.current.cell.w,
                       Map.current.cell.h, 4)
end

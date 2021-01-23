-- encapsulate cursor state
Cursor = {
    -- A* pathfinder
    astar = AStar:new(),

    -- path found by A*
    path = {},

    -- current cursor cell position
    cell = {x = 0, y = 0},

    -- selected unit
    sel = false,

    -- record the position of the cursor when each player's turn ends
    -- TODO: move into Player?
    -- TODO: can probably refactor into single table
    last = {
        {x = nil, y = nil}, -- p1
        {x = nil, y = nil}, -- p2
    },

    -- frame counter used for animations
    frame = 0,
}

-- update cursor state
function Cursor:update()
    -- left/right
    if BtnLeft:rep() and self.cell.x > 0 then
        self.cell.x = self.cell.x - 1
    elseif BtnRight:rep() and self.cell.x < Map.current.cell.w - 1 then
        self.cell.x = self.cell.x + 1
    end

    -- up/down
    if BtnUp:rep() and self.cell.y > 0 then
        self.cell.y = self.cell.y - 1
    elseif BtnDown:rep() and self.cell.y < Map.current.cell.h - 1 then
        self.cell.y = self.cell.y + 1
    end

    -- "X"
    if BtnX:once() then
        -- determine whether a unit is beneath the cursor
        local unit, idx = Unit.at(self.cell.x, self.cell.y, Map.current.units)

        -- if there is a unit beneath the cursor...
        if unit then
            -- select friendly unit:
            if unit:friend(Turn.player) and not self:selected(unit) and
                unit.active then
                self.sel = unit
                Radius:update(unit, Map.current, Turn.player)

                -- open friendly balance menu:
            elseif unit:friend(Turn.player) and self:selected(unit) and
                not unit:acted() then
                MenuBalance.sel = 1
                MenuBalance.vis = true
                -- TODO: end turn after balancing

                -- view enemy radii:
            elseif unit:foe(Turn.player) and not self:selected() then
                -- TODO
                printh("TODO")

                -- attack enemy:
                -- TODO: handle attack power of 0
            elseif unit:foe(Turn.player) and self:selected() and
                not self.sel:attacked() and self.sel.active and
                Radius:contains('atk', unit.cell.x, unit.cell.y) then

                -- attack the enemy unit
                self.sel:attack(unit, idx)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(Map.current.units, Turn.player)
                self.sel:activate()

                -- end the player's turn if the unit is exhausted
                if self.sel:exhausted() then
                    self.sel = false
                    Radius:clear()
                    Turn:turn_end()
                    -- otherwise, show the movement radius
                else
                    Radius:update(self.sel, Map.current, Turn.player)
                end
            end

            -- if no unit is beneath the cursor...
        elseif not unit then
            -- move friendly unit:
            if self:selected() and self.sel.active and not self.sel:moved() and
                Cell.open(self.cell.x, self.cell.y, Map.current) and
                Radius:contains('mov', self.cell.x, self.cell.y) then

                -- move the unit
                self.sel:move(self.cell.x, self.cell.y)

                -- deactivate all *other* units belonging to the player
                Units.deactivate(Map.current.units, Turn.player)
                self.sel:activate()

                -- reset the animation delay
                Units.delay = 30

                -- end the player's turn if the unit is exhausted
                if self.sel:exhausted() then
                    self.sel = false
                    Radius:clear()
                    Turn:turn_end()
                    -- otherwise, show the attack radius
                else
                    Radius:update(self.sel, Map.current, Turn.player)
                end

                -- show "turn end" menu
            elseif not self:selected() then
                MenuTurnEnd.sel = 1
                MenuTurnEnd.vis = true
            end
        end
    end

    -- "Z"
    -- unselect a selected unit
    if BtnZ:once() and self:selected() then
        self.sel = false
        Radius:clear()
    end

    if self:selected() and Radius:contains('mov', self.cell.x, self.cell.y) then
        self.path = self.astar:search(
                        Cell:new(self.sel.cell.x, self.sel.cell.y,
                                 Map.current.cell.w),
                        Cell:new(self.cell.x, self.cell.y, Map.current.cell.w))
    else
        self.path = {}
    end
end

-- Return true if `unit` unit is selected, or true if any unit is selected
-- otherwise
function Cursor:selected(unit)
    if unit then return self.sel and (self.sel == unit) end
    return self.sel
end

-- clear resets the cursor
function Cursor:clear()
    self.last = {
        {x = nil, y = nil}, -- p1
        {x = nil, y = nil}, -- p2
    }
end

-- render the cursor
function Cursor:draw()
    local sprite = 16
    if self.frame < 30 then
        sprite = 32
    elseif self.frame > 60 then
        self.frame = 0
    end

    -- increment the frame counter
    self.frame = self.frame + 1

    -- draw the A* path
    for _, cell in ipairs(self.path) do spr(34, cell.x * 8, cell.y * 8) end

    -- draw the sprite
    spr(sprite, self.cell.x * 8, self.cell.y * 8)
end

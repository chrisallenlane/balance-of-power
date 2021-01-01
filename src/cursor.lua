-- encapsulate cursor state
Cursor = {
    -- current cursor cell position
    cell = {x = 0, y = 0, spr = 0},

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
    if BtnLeft:btnp() and self.cell.x > 0 then
        self.cell.x = self.cell.x - 1
    elseif BtnRight:btnp() and self.cell.x < Map.current.cell.w - 1 then
        self.cell.x = self.cell.x + 1
    end

    -- up/down
    if BtnUp:btnp() and self.cell.y > 0 then
        self.cell.y = self.cell.y - 1
    elseif BtnDown:btnp() and self.cell.y < Map.current.cell.h - 1 then
        self.cell.y = self.cell.y + 1
    end

    -- "X"
    -- move a unit
    if BtnX:btnp() then
        -- determine whether a unit is beneath the cursor
        local unit, idx = Unit.at(self.cell.x, self.cell.y, Map.current.units)

        -- if a player unit is available beneath the cursor, select it
        if unit and unit.player == Turn.player then
            self.sel = unit
            Radius:update(unit, Map.current, Turn.player)

            -- if there is no unit beneath our cursor, and we have a unit
            -- selected, and the terrain beneath our cursor is passable, move the
            -- unit
        elseif not unit and self.sel and
            Cell.open(self.cell.x, self.cell.y, Map.current) and
            Radius:contains('move', self.cell.x, self.cell.y) then
            -- move the unit
            self.sel:move(self.cell.x, self.cell.y)
            Radius:clear()
            Units.delay = 30

            -- clear the unit selection
            self.sel = false

            -- end the player's turn
            Turn:turn_end()

        elseif not unit and not self.sel then
            MenuTurnEnd.sel = 1
            MenuTurnEnd.vis = true
        end

        -- Attack:
        -- 1. if we have a friendly unit selected
        -- 2. and the cursor is over a unit
        -- 3. and that unit is an enemy unit
        -- 4. and that unit is within our attack range
        if self.sel and unit and unit.player ~= Turn.player and
            Radius:contains('atk', unit.cell.x, unit.cell.y) then
            unit.die(idx, Map.current.units)
            Radius:clear()
            Turn:turn_end()
        end
    end

    -- "Z"
    -- unselect a selected unit
    if BtnZ:btnp() and self.sel then
        self.sel = false
        Radius:clear()
    end
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

    -- draw the sprite
    spr(sprite, self.cell.x * 8, self.cell.y * 8)
end

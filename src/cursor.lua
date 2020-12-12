-- encapsulate cursor state
Cursor = {
    -- current cursor cell position
    cell = {x = 0, y = 0, spr = 0, pass = true},

    -- selected unit
    sel = false,

    -- record the position of the cursor when each player's turn ends
    -- TODO: move into Player?
    last = {
        {x = nil, y = nil}, -- p1
        {x = nil, y = nil}, -- p2
    },

    -- frame counter used for animations
    frame = 0,
}

-- update cursor state
function Cursor:update()
    -- TODO: move this lock outside of this method
    -- if a unit is in-motion, lock the cursor
    if Lock.unit or Lock.camera then return end

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

    -- determine whether the cell is passable
    self.cell.pass = Cell.passable(self.cell.x, self.cell.y, Map.current)

    -- "X"
    -- move a unit
    if BtnX:btnp() then
        -- determine whether a unit is beneath the cursor
        local unit = Unit.at(self.cell.x, self.cell.y, Map.current.units)

        -- if a player unit is available beneath the cursor, select it
        if unit and unit.team == Turn.player then
            self.sel = unit

            -- if there is no unit beneath our cursor, and we have a unit
            -- selected, and the terrain beneath our cursor is passable, move the
            -- unit
        elseif not unit and self.sel and self.cell.pass then
            -- move the unit
            self.sel:move(self.cell.x, self.cell.y)

            -- clear the unit selection
            self.sel = false

            -- end the player's turn
            Turn:turn_end()

        elseif not unit and not self.sel then
            MenuTurnEnd.sel = 1
            MenuTurnEnd.vis = true
        end

        -- TODO: handle selection of enemy units
    end

    -- "Z"
    -- unselect a selected unit
    if BtnZ:btnp() and self.sel then self.sel = false end
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

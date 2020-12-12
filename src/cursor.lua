-- encapsulate cursor state
Cursor = {
    cell = {x = 0, y = 0, spr = 0, pass = true},
    sel = false,

    -- record the position of the cursor when each player's turn ends
    last = {[1] = {x = nil, y = nil}, [2] = {x = nil, y = nil}},

    frame = 0,
}

-- update cursor state
function Cursor:update()
    -- TODO: move this lock outside of this method
    -- if a unit is in-motion, lock the cursor
    if Lock.unit or Lock.camera then return end

    -- TODO: externalize this logic elsewhere
    -- NB: this is a stub
    -- move the CPU player
    if Turn.player == 2 and Game.state.cpu then
        local mv = -1

        -- select the first enemy unit
        local unit = Unit.first(2, Map.current.units)

        -- if moving left is invalid, move right
        if not Cell.passable(unit.cell.x + mv, unit.cell.y, Map.current) then
            mv = mv * -1
        end

        -- pause in place for a moment before the CPU moves
        if Delay.cpu > 0 then
            Delay.cpu = Delay.cpu - 1
            return
        end
        Delay.cpu = 30

        -- move the unit and end the turn
        unit:move(unit.cell.x + mv, unit.cell.y)
        Turn:turn_end()
        return
    end

    -- left/right
    if Left:btnp() and self.cell.x > 0 then
        self.cell.x = self.cell.x - 1
    elseif Right:btnp() and self.cell.x < Map.current.cell.w - 1 then
        self.cell.x = self.cell.x + 1
    end

    -- up/down
    if Up:btnp() and self.cell.y > 0 then
        self.cell.y = self.cell.y - 1
    elseif Down:btnp() and self.cell.y < Map.current.cell.h - 1 then
        self.cell.y = self.cell.y + 1
    end

    -- determine whether the cell is passable
    self.cell.pass = Cell.passable(self.cell.x, self.cell.y, Map.current)

    -- "X"
    -- move a unit
    if btnp(5) then
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
    if btnp(4) and self.sel then self.sel = false end
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

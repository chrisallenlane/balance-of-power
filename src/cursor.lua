-- encapsulate cursor state
Cursor = {
    cell = {x = 0, y = 0, spr = 0, pass = true},
    sel = false,
    turn = 1,

    -- track if the cursor is moving in a direction
    move = {d = false, l = false, r = false, u = false},

    -- regulate cursor speed by manually implementing `btnp`-like
    -- functionality
    delay = {[0] = 3, [1] = 3, [2] = 3, [3] = 3},

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
        local unit = Unit.first(2, Game.map.units)

        -- if moving left is invalid, move right
        if not Cell.passable(unit.cell.x + mv, unit.cell.y, Game.map) then
            mv = mv * -1
        end

        -- pause in place for a moment before the CPU moves
        if Game.delay.cpu > 0 then
            Game.delay.cpu = Game.delay.cpu - 1
            return
        end
        Game.delay.cpu = 30

        -- move the unit and end the turn
        unit:move(unit.cell.x + mv, unit.cell.y)
        Turn:turn_end()
        return
    end

    -- don't register a re-press until `wait` frames
    local wait = 7

    -- left
    if btn(0) and self.cell.x > 0 then
        self.move.l = true
        self.delay[0] = self.delay[0] + 1
        if self.delay[0] >= wait then
            self.delay[0] = 0
            self.cell.x = self.cell.x - 1
        end
    elseif not btn(0) then
        self.delay[0] = wait - 1
        self.move.l = false
    end

    -- right
    if btn(1) and self.cell.x < Game.map.cell.w - 1 then
        self.move.r = true
        self.delay[1] = self.delay[1] + 1
        if self.delay[1] >= wait then
            self.delay[1] = 0
            self.cell.x = self.cell.x + 1
        end
    elseif not btn(1) then
        self.delay[1] = wait - 1
        self.move.r = false
    end

    -- up
    if btn(2) and self.cell.y > 0 then
        self.move.u = true
        self.delay[2] = self.delay[2] + 1
        if self.delay[2] >= wait then
            self.delay[2] = 0
            self.cell.y = self.cell.y - 1
        end
    elseif not btn(2) then
        self.delay[2] = wait - 1
        self.move.u = false
    end

    -- down
    if btn(3) and self.cell.y < Game.map.cell.h - 1 then
        self.move.d = true
        self.delay[3] = self.delay[3] + 1
        if self.delay[3] >= wait then
            self.delay[3] = 0
            self.cell.y = self.cell.y + 1
        end
    elseif not btn(3) then
        self.delay[3] = wait - 1
        self.move.d = false
    end

    -- determine whether the cell is passable
    self.cell.pass = Cell.passable(self.cell.x, self.cell.y, Game.map)

    -- "X"
    -- move a unit
    if btnp(5) then

        -- determine whether a unit is beneath the cursor
        local unit = Unit.at(self.cell.x, self.cell.y, Game.map.units)

        -- if a player unit is available beneath the cursor, select it
        if unit and unit.team == self.turn then
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


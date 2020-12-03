-- encapsulate cursor state
game.cursor = {
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
}

-- update cursor state
function game.cursor:update()

    -- don't register a re-press until `frame` frames
    local frame = 4

    -- left
    if btn(0) and self.cell.x > 0 then
        self.move.l = true
        self.delay[0] = self.delay[0] + 1
        if self.delay[0] >= frame then
            self.delay[0] = 0
            self.cell.x = self.cell.x - 1
        end
    elseif not btn(0) then
        self.delay[0] = frame - 1
        self.move.l = false
    end

    -- right
    if btn(1) and self.cell.x < game.map.cell.w - 1 then
        self.move.r = true
        self.delay[1] = self.delay[1] + 1
        if self.delay[1] >= frame then
            self.delay[1] = 0
            self.cell.x = self.cell.x + 1
        end
    elseif not btn(1) then
        self.delay[1] = frame - 1
        self.move.r = false
    end

    -- up
    if btn(2) and self.cell.y > 0 then
        self.move.u = true
        self.delay[2] = self.delay[2] + 1
        if self.delay[2] >= frame then
            self.delay[2] = 0
            self.cell.y = self.cell.y - 1
        end
    elseif not btn(2) then
        self.delay[2] = frame - 1
        self.move.u = false
    end

    -- down
    if btn(3) and self.cell.y < game.map.cell.h - 1 then
        self.move.d = true
        self.delay[3] = self.delay[3] + 1
        if self.delay[3] >= frame then
            self.delay[3] = 0
            self.cell.y = self.cell.y + 1
        end
    elseif not btn(3) then
        self.delay[3] = frame - 1
        self.move.d = false
    end

    -- get the ID of the sprite beneath the cursor
    self.cell.spr = mget(game.map.cell.x + self.cell.x,
                         game.map.cell.y + self.cell.y)

    -- determine whether the cell is passable
    if fget(self.cell.spr, 0) then
        self.cell.pass = false
    else
        self.cell.pass = true
    end

    -- "X"
    -- move a unit
    if btnp(5) then

        -- determine whether a unit is beneath the cursor
        local unit = Unit.at(self.cell.x, self.cell.y, game.map.units)

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
            self:turn_end()

        elseif not unit and not self.sel then
            game.screens.battle.menu.sel = 1
            game.screens.battle.menu.vis = true
        end

        -- TODO: handle selection of enemy units
    end

    -- "Z"
    -- unselect a selected unit
    if btnp(4) and self.sel then self.sel = false end
end

-- render the cursor
function game.cursor:draw()
    spr(16, self.cell.x * 8, self.cell.y * 8)
end

-- change the player turn
function game.cursor:turn_end()

    -- record the current player's cursor position
    self.last[self.turn] = {x = self.cell.x, y = self.cell.y}

    -- end the turn
    if self.turn == 1 then
        self.turn = 2
    else
        self.turn = 1
    end

    -- load the next player's cursor
    if self.last[self.turn].x == nil or self.last[self.turn].y == nil then
        local unit = Unit.first(self.turn, game.map.units)
        self.cell.x = unit.cell.x
        self.cell.y = unit.cell.y
    else
        self.cell.x = self.last[self.turn].x
        self.cell.y = self.last[self.turn].y
    end

    -- center the screen on the specified coordinates
    game.camera:focus(self.cell.x, self.cell.y, game.map.cell.w, game.map.cell.h)
end

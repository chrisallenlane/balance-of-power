-- encapsulate cursor state
game.cursor = {
    cell = {x = 0, y = 0, spr = 0, pass = true},
    sel = false,
    turn = 1,

    -- track if the cursor is moving in a direction
    move = {d = false, l = false, r = false, u = false},

    -- TODO: encapsulate these in a table
    btn_0 = 3,
    btn_1 = 3,
    btn_2 = 3,
    btn_3 = 3,
}

-- update cursor state
function game.cursor:update()

    -- don't register a re-press until `frame` frames
    local frame = 4

    -- left
    if btn(0) and self.cell.x > 0 then
        self.move.l = true
        self.btn_0 = self.btn_0 + 1
        if self.btn_0 >= frame then
            self.btn_0 = 0
            self.cell.x = self.cell.x - 1
        end
    elseif not btn(0) then
        self.btn_0 = frame - 1
        self.move.l = false
    end

    -- right
    if btn(1) and self.cell.x < game.map.cell.w - 1 then
        self.move.r = true
        self.btn_1 = self.btn_1 + 1
        if self.btn_1 >= frame then
            self.btn_1 = 0
            self.cell.x = self.cell.x + 1
        end
    elseif not btn(1) then
        self.btn_1 = frame - 1
        self.move.r = false
    end

    -- up
    if btn(2) and self.cell.y > 0 then
        self.move.u = true
        self.btn_2 = self.btn_2 + 1
        if self.btn_2 >= frame then
            self.btn_2 = 0
            self.cell.y = self.cell.y - 1
        end
    elseif not btn(2) then
        self.btn_2 = frame - 1
        self.move.u = false
    end

    -- down
    if btn(3) and self.cell.y < game.map.cell.h - 1 then
        self.move.d = true
        self.btn_3 = self.btn_3 + 1
        if self.btn_3 >= frame then
            self.btn_3 = 0
            self.cell.y = self.cell.y + 1
        end
    elseif not btn(3) then
        self.btn_3 = frame - 1
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
    if self.turn == 1 then
        self.turn = 2
    else
        self.turn = 1
    end
end

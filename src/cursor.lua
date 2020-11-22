-- encapsulate cursor state
game.cursor = {
    cell = {x = 0, y = 0, spr = 0, pass = true},
    sel = {x = nil, y = nil},
    turn = "p1",

    -- track if the cursor is moving in a direction
    move = {d = false, l = false, r = false, u = false},

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
    self.cell.spr = mget(self.cell.x, self.cell.y)

    -- determine whether the cell is passable
    if fget(self.cell.spr, 0) then
        self.cell.pass = false
    else
        self.cell.pass = true
    end

    -- "X"
    -- move a unit
    if btnp(5) then
        -- if a player unit is available beneath the cursor, select it
        if game.map.units[self.turn][self.cell.x] and
            game.map.units[self.turn][self.cell.x][self.cell.y] then
            self.sel.x, self.sel.y = self.cell.x, self.cell.y

            -- if we have a unit selected, attempt to move it
        elseif self.sel.x then

            -- TODO: ensure that the cursor's current position is not on
            -- impassible terrain
            if self.cell.pass then
                -- TODO: account for a movement radius
                -- TODO: account for player 2

                -- vivify the map table if it does not exist
                if not game.map.units[self.turn][self.cell.x] then
                    game.map.units[self.turn][self.cell.x] = {}
                end

                -- move the selected unit to the current cursor position
                game.map.units[self.turn][self.cell.x][self.cell.y] =
                    game.map.units[self.turn][self.sel.x][self.sel.y]

                -- remove the prior reference to the unit
                game.map.units[self.turn][self.sel.x][self.sel.y] = nil

                -- clear the unit selection
                self.sel.x, self.sel.y = nil, nil

                -- automatically end the player's turn after a unit has been
                -- moved
                self:turn_end()
            end
        end

        -- TODO: handle selection of enemy units
    end

    -- "Z"
    -- unselect a selected unit
    -- TODO: restore this functionality
    -- if btnp(4) then self.sel.x, self.sel.y = nil, nil end

    -- "Z"
    -- end the player's turn
    if btnp(4) then self:turn_end() end
end

-- render the cursor
function game.cursor:draw()
    spr(16, self.cell.x * 8, self.cell.y * 8)
end

-- change the player turn
function game.cursor:turn_end()
    if self.turn == "p1" then
        self.turn = "p2"
    else
        self.turn = "p1"
    end
end

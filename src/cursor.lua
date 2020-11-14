-- encapsulate cursor state
game.cursor = {
    cell = {x = 0, y = 0, spr = 0, pass = true},
    direction = "stop",
    sel = {x = nil, y = nil},

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
        self.direction = "left"
        self.btn_0 = self.btn_0 + 1
        if self.btn_0 >= frame then
            self.btn_0 = 0
            self.cell.x = self.cell.x - 1
        end
    elseif not btn(0) then
        self.btn_0 = frame - 1
    end

    -- right
    if btn(1) and self.cell.x < game.map.cell.w - 1 then
        self.direction = "right"
        self.btn_1 = self.btn_1 + 1
        if self.btn_1 >= frame then
            self.btn_1 = 0
            self.cell.x = self.cell.x + 1
        end
    elseif not btn(1) then
        self.btn_1 = frame - 1
    end

    -- up
    if btn(2) and self.cell.y > 0 then
        self.direction = "up"
        self.btn_2 = self.btn_2 + 1
        if self.btn_2 >= frame then
            self.btn_2 = 0
            self.cell.y = self.cell.y - 1
        end
    elseif not btn(2) then
        self.btn_2 = frame - 1
    end

    -- down
    if btn(3) and self.cell.y < game.map.cell.h - 1 then
        self.direction = "down"
        self.btn_3 = self.btn_3 + 1
        if self.btn_3 >= frame then
            self.btn_3 = 0
            self.cell.y = self.cell.y + 1
        end
    elseif not btn(3) then
        self.btn_3 = frame - 1
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
        if game.map.units.p1[self.cell.x] and
            game.map.units.p1[self.cell.x][self.cell.y] then
            self.sel.x, self.sel.y = self.cell.x, self.cell.y

            -- if we have a unit selected, attempt to move it
        elseif self.sel.x then

            -- TODO: ensure that the cursor's current position is not on
            -- impassible terrain
            if self.cell.pass then
                -- TODO: account for a movement radius
                -- TODO: account for player 2

                -- vivify the map table if it does not exist
                if not game.map.units.p1[self.cell.x] then
                    game.map.units.p1[self.cell.x] = {}
                end

                -- move the selected unit to the current cursor position
                game.map.units.p1[self.cell.x][self.cell.y] =
                    game.map.units.p1[self.sel.x][self.sel.y]

                -- remove the prior reference to the unit
                game.map.units.p1[self.sel.x][self.sel.y] = nil

                -- clear the unit selection
                self.sel.x, self.sel.y = nil, nil
            end
        end

        -- TODO: handle selection of enemy units
    end

    -- "Z"
    -- unselect a selected unit
    if btnp(4) then self.sel.x, self.sel.y = nil, nil end
end

-- render the cursor
function game.cursor:draw()
    spr(16, self.cell.x * 8, self.cell.y * 8)
end

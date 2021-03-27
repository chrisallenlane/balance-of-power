Cursor = {}

function Cursor:new()
    local c = {
        -- current cursor cell position
        cell = {x = 0, y = 0},

        -- the currently selected unit
        -- TODO: remove the `unit` wrapper if I never add additional properties
        unit = {sel = nil},

        -- frame counter used for animations
        frame = 0,
    }

    setmetatable(c, self)
    self.__index = self
    return c
end

-- update cursor state
function Cursor:update(stage, inputs)
    -- for brevity
    local cell = self.cell

    -- left/right
    if inputs.left:rep() and cell.x > 0 then
        cell.x = cell.x - 1
    elseif inputs.right:rep() and cell.x < stage.cell.w - 1 then
        cell.x = cell.x + 1
    end

    -- up/down
    if inputs.up:rep() and cell.y > 0 then
        cell.y = cell.y - 1
    elseif inputs.down:rep() and cell.y < stage.cell.h - 1 then
        cell.y = cell.y + 1
    end
end

-- TODO: move this into unit state
-- Return true if `unit` unit is selected, or true if any unit is selected
-- otherwise
function Cursor:selected(unit)
    if unit then return self.unit.sel and (self.unit.sel == unit) end
    return self.unit.sel
end

-- immediately move the cursor to the specified cell coordinates
function Cursor:warp(x, y)
    self.cell.x, self.cell.y = x, y
end

-- render the cursor
function Cursor:draw()
    local sprite = 4
    if self.frame < 30 then
        sprite = 5
    elseif self.frame > 60 then
        self.frame = 0
    end

    -- increment the frame counter
    self.frame = self.frame + 1

    -- draw the A* path
    for _, cell in ipairs(self.path) do spr(6, cell.x * 8, cell.y * 8) end

    -- draw the sprite
    spr(sprite, self.cell.x * 8, self.cell.y * 8)
end

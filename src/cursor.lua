Cursor = {}

function Cursor:new()
    local c = {
        -- current cursor cell position
        cell = {x = 0, y = 0},

        -- the currently selected unit
        -- @todo: remove the `unit` wrapper if I never add additional properties
        unit = {sel = nil},

        -- is the cursor visible?
        vis = true,

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

-- @todo: move this into unit state
-- Return true if `unit` unit is selected, or true if any unit is selected
-- otherwise
function Cursor:selected(unit)
    if unit then return self.unit.sel and (self.unit.sel == unit) end
    return self.unit.sel
end

-- immediately move the cursor to the specified cell coordinates
function Cursor:warp(x, y)
    self.cell = {x = x, y = y}
end

-- render the cursor
-- NB: if I become desperate tokens, I can eliminate the cursor "throb"
function Cursor:draw(state)
    -- end early if the cursor should not be visible
    if not self.vis or not Seq:done() or state.talk.vis then return end

    -- choose the appropriate sprite
    local sprite = 1
    if self.frame < 30 then
        sprite = 2
    elseif self.frame > 60 then
        self.frame = 0
    end

    -- increment the frame counter
    self.frame = self.frame + 1

    -- draw the sprite
    spr(sprite, self.cell.x * 8, self.cell.y * 8)
end

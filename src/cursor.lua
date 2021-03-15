-- encapsulate cursor state
Cursor = {
    -- A* pathfinder
    astar = AStar:new(),

    -- path found by A*
    path = {},

    -- current cursor cell position
    cell = {x = 0, y = 0},

    -- selected unit
    -- TODO: this could use a refactoring
    sel = nil,

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
function Cursor:update(map, inputs)
    -- left/right
    if inputs.left:rep() and self.cell.x > 0 then
        self.cell.x = self.cell.x - 1
    elseif inputs.right:rep() and self.cell.x < map.cell.w - 1 then
        self.cell.x = self.cell.x + 1
    end

    -- up/down
    if inputs.up:rep() and self.cell.y > 0 then
        self.cell.y = self.cell.y - 1
    elseif inputs.down:rep() and self.cell.y < map.cell.h - 1 then
        self.cell.y = self.cell.y + 1
    end
end

-- TODO: move this into unit state
-- Return true if `unit` unit is selected, or true if any unit is selected
-- otherwise
function Cursor:selected(unit)
    if unit then return self.sel and (self.sel == unit) end
    return self.sel
end

-- clear resets the cursor
function Cursor:clear()
    self.last = {
        {x = nil, y = nil}, -- p1
        {x = nil, y = nil}, -- p2
    }
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

    -- draw the A* path
    for _, cell in ipairs(self.path) do spr(34, cell.x * 8, cell.y * 8) end

    -- draw the sprite
    spr(sprite, self.cell.x * 8, self.cell.y * 8)
end

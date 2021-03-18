AStar = {}

-- TODO: handle unreachable tiles
-- TODO: depth limit param
-- TODO: d param
-- TODO: wrap in generator
-- TODO: return `done` value

function AStar:new(a)
    a = a or {}
    setmetatable(a, self)
    self.__index = self

    -- initialize a queue
    a.queue = Queue:new()

    -- manhattan distance on a square grid
    if not a.h then
        a.h = function(start, goal)
            return abs(start.x - goal.x) + abs(start.y - goal.y)
        end
    end

    return a
end

function AStar:search(start, goal, stage)
    local open, closed, current = {}, {}, {}
    local path_cost = {[start.id] = 0}

    -- begin searching from the `start` cell
    self.queue.put(open, start, 0)

    -- explore unexplored cells
    while (open) do
        -- select a cell to explore
        current = self.queue.pop(open)

        -- break if we've reached the goal
        if current:is(goal) then break end

        for neighbor in all(Cell.neighbors(current.x, current.y, stage)) do
            -- TODO: use the appropriate name here
            -- TODO: refactor this
            local new_cost = path_cost[current.id] +
                                 Cell.cost(neighbor.x, neighbor.y, stage)

            if (path_cost[neighbor.id] == nil) or
                (new_cost < path_cost[neighbor.id]) then

                path_cost[neighbor.id] = new_cost

                self.queue
                    .put(open, neighbor, new_cost + self.h(goal, neighbor))
                neighbor.parent = current

                if not neighbor:is(start) and not neighbor:is(goal) then
                    add(closed, neighbor)
                end
            end
        end
    end

    -- when we are finished exploring the frontier...
    local path = {}
    while not current:is(start) do
        add(path, current)
        current = current.parent
    end

    -- reverse the paths, so they're arranged `start` => `end` rather than
    -- `end` => `start`
    -- TODO: work from goal to start to elimate the need for this
    self.queue.reverse(path)

    -- return the `winning` path and the searched cells
    return path, closed
end

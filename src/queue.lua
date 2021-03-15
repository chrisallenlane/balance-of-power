Queue = {}

-- Queue constructor
function Queue:new()
    local q = {}
    setmetatable(q, self)
    self.__index = self
    return q
end

-- pop an element from a table
function Queue.pop(t)
    local top = t[#t]
    del(t, t[#t])
    return top[1]
end

-- reverses a table
function Queue.reverse(t)
    for i = 1, (#t / 2) do
        local temp = t[i]
        local oppindex = #t - (i - 1)
        t[i] = t[oppindex]
        t[oppindex] = temp
    end
end

-- insert into table and sort by priority
function Queue.put(t, val, p)
    add(t, {})
    for i = (#t), 2, -1 do
        local next = t[i - 1]
        if p < next[2] then
            t[i] = {val, p}
            return
        end
        t[i] = next
    end
    t[1] = {val, p}
end

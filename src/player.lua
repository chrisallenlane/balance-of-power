Player = {battle = {}}

-- define the constructor
function Player:new(p)
    setmetatable(p, self)
    self.__index = self

    -- each player owns a cursor
    p.cursor = Cursor:new()

    return p
end

-- return true if the current player is a human
function Player:human(players)
    return not players[self.num].cpu
end

-- change the player turn
function Player:turnEnd(state)
    local cam = state.camera

    -- hide radii
    Radius.clearAll(state.stage.units)

    -- unselect the unit
    state.player.cursor.unit.sel = nil

    -- refresh all units
    Units.refresh(state.stage.units)

    -- swap the current player
    state.player = self.num == 1 and state.players[2] or state.players[1]

    -- repair units (that belong to the new player) that are in a city
    Units.repair(state)

    -- center the screen on the specified coordinates
    local cur = state.player.cursor
    Seq:enqueue({
        Anim.delay(30),
        function()
            cam:focus(cur.cellx, cur.celly, state)
            return true
        end,
        Anim.trans(cam, cam.cellx, cam.celly),
    })
end

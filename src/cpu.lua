CPU = {}

function CPU.update()
    if Lock.unit or Lock.camera then return end

    -- NB: this is a stub
    -- move the CPU player
    local mv = -1

    -- select the first enemy unit
    local unit = Unit.first(2, Map.current.units)

    -- if moving left is invalid, move right
    if not Cell.passable(unit.cell.x + mv, unit.cell.y, Map.current) then
        mv = mv * -1
    end

    -- pause in place for a moment before the CPU moves
    if Delay.cpu > 0 then
        Delay.cpu = Delay.cpu - 1
        return
    end
    Delay.cpu = 30

    -- move the unit and end the turn
    unit:move(unit.cell.x + mv, unit.cell.y)
    Turn:turn_end()
    return
end

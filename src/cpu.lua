CPU = {battle = {}, delay = 0}

-- NB: this is a stub
function CPU.battle.update()
    Info:set("", "")

    -- pause in place for a moment before the CPU moves
    if CPU.delay > 0 then
        CPU.delay = CPU.delay - 1
        return
    end

    local mv = -1

    -- select the first enemy unit
    local unit = Units.first(2, Map.current.units)

    -- if moving left is invalid, move right
    if not Cell.pass(unit.cell.x + mv, unit.cell.y, Map.current, Player.num) then
        mv = mv * -1
    end

    -- move the unit and end the turn
    unit:move(unit.cell.x + mv, unit.cell.y)

    -- reset delays
    CPU.delay = 30
    Units.delay = 30

    -- end the CPU turn
    Player:turn_end()
end

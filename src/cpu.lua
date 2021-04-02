CPU = {battle = {}, delay = 0}

-- NB: this is a stub
function CPU.battle.update(state)
    Info:set("", "")

    local player = state.player

    -- pause in place for a moment before the CPU moves
    if CPU.delay > 0 then
        CPU.delay = CPU.delay - 1
        return
    end

    local mv = -1

    -- select the first enemy unit
    local unit = Units.first(2, state.stage.units)

    -- if moving left is invalid, move right
    if not Cell.pass(unit.cell.x + mv, unit.cell.y, state.stage, player.num) then
        mv = mv * -1
    end

    local newx, newy = unit.cell.x + mv, unit.cell.y

    -- move the unit and end the turn
    unit:move(newx, newy)

    Seq:enqueue({Anim.delay(30), Anim.trans(unit, newx, newy)})

    -- KLUDGE
    player.cursor.cell.x = unit.cell.x + mv
    player.cursor.cell.y = unit.cell.y

    -- end the CPU turn
    player:turnEnd(state)
end

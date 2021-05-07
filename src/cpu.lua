CPU = {battle = {}}

-- NB: this is a stub
function CPU.battle.update(state)
    Info:set("", "")

    local player, stage = state.player, state.stage

    -- select an enemy unit at random
    -- TODO: it might be worth refactoring this into a "filter" method or
    -- something
    local units = {}
    for _, u in pairs(state.stage.units) do
        if u.player == 2 then add(units, u) end
    end
    local unit = rnd(units)

    -- calculate the unit's radius
    unit.radius:update(unit, stage, 2)

    -- select a random cell within the movement radius
    local cell = unit.radius:rand('mov', state)

    -- move the unit
    unit:move(cell.x, cell.y)

    -- unqueue the animations
    Seq:enqueue({Anim.delay(30), Anim.trans(unit, cell.x, cell.y)})

    -- record the CPU's (fake) cursor location
    player.cursor.cell.x, player.cursor.cell.y = cell.x, cell.y

    -- end the CPU turn
    player:turnEnd(state)
end

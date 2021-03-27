-- update the battle screen
function Screens.battle.update(state, inputs)
    -- return early if an animation is playing
    if Seq:play() then return end

    -- only move the camera if units have finished moving
    -- TODO: get rid of this
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            state.camera:update(state)
        end
    end

    -- determine if the stage has been cleared
    local clear, victor = Stage.clear(state)

    -- handle stage clears
    if clear then
        state.player.cursor.vis = false
        Radius.clearAll(state.stage.units)
        Seq:enqueue(Anim.delay(120))

        -- handle 1-player games
        if state.players[2].cpu then
            if victor == 1 then
                Banner:show(1, "victory")
                Seq:enqueue(Anim.delay(300))
                Seq:enqueue(function()
                    Banner:hide()
                    state.stage:advance(Stages, Screens, state)
                    return true
                end)
            else
                Banner:show(2, "defeat")
                Seq:enqueue(Anim.delay(300))
                Seq:enqueue(function()
                    Banner:hide()
                    state.screen = Screens.defeat
                    return true
                end)
            end

            -- handle 2-player games
        else
            -- display the winning player's banner
            Banner:show(victor, "player " .. victor .. " victory")

            -- delay, then go to the title screen (or where?)
            Seq:enqueue(Anim.delay(300))
            Seq:enqueue(function()
                Banner:hide()
                state.screen = Screens.title
                return true
            end)
        end

        return
    end

    -- do not run player/CPU update loops if a lock is engaged
    if state.camera.ready and Units.ready then
        if state.player:human(state.players) then
            -- update the menu if it is visible
            if state.menu then
                state.menu:update(state, inputs)
                return
            end
            -- update the cursor state
            state.player.cursor:update(state.stage, inputs)

            -- update the battle state
            Player.battle.update(state, inputs)
        else
            CPU.battle.update(state)
        end
    end

    Units.update(state)
end

-- draw the battle screen
function Screens.battle.draw(state)
    cls()

    -- move the camera
    state.camera:draw()

    -- draw the stage
    Stage.draw(state)

    -- TODO: move this elsewhere
    for _, unit in pairs(state.stage.units) do
        unit.radius:draw(unit.player == state.player.num)
    end

    -- draw the cursor (if the player is a human)
    if state.player:human(state.players) then state.player.cursor:draw() end

    -- draw units and their radii
    Units.draw(state)

    -- draw menus
    if state.menu then state.menu:draw(state) end

    -- draw the info bar
    Info:draw(state)

    -- draw the victory/loss banner
    Banner:draw(state)

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars(state) end
end

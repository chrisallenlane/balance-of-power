-- update the battle screen
function Screens.battle.update(state, inputs)
    -- only move the camera if units have finished moving
    if Units.ready then
        if Units.delay > 0 then
            Units.delay = Units.delay - 1
        else
            state.camera:update(state)
        end
    end

    -- determine if the stage has been cleared
    local clear, victor = Stage.clear(state)

    -- handle 1-player games
    if state.players[2].cpu then
        if clear and victor == 1 then
            -- TODO: display "victory" banner
            state.stage:advance(Stages, Screens, state)
            return
        elseif clear and victor == 2 then
            -- TODO: display "defeat" banner
            state.screen = Screens.defeat
            return
        end

        -- handle 2-player games
    else
        if clear then
            if victor == 1 then
                -- TODO: display "player 1 wins" banner
                printh("TODO")
            else
                -- TODO: display "player 2 wins" banner
                printh("TODO")
            end

            -- return to title screen
            -- TODO: return to map select screen?
            state.screen = Screens.title
            return
        end
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

    -- display debug output (if so configured)
    if DEBUG_SHOW then Debug.vars(state) end
end

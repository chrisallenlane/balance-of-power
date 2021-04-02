-- update the battle screen
function Screens.battle.update(state, inputs)
    -- return early if an animation is playing
    if Seq:play() then return end

    state.camera:focus(state.player.cursor.cell.x, state.player.cursor.cell.y,
                       state)
    state.camera:update(state)

    -- determine if the stage has been cleared
    local clear, victor = Stage.clear(state)

    -- handle stage clears
    if clear then
        state.player.cursor.vis = false
        Radius.clearAll(state.stage.units)
        Seq:enqueue({Anim.delay(120)})

        -- handle 1-player games
        if state.players[2].cpu then
            if victor == 1 then
                -- show player 1 "victory" banner for 300 frames, then advance to the next stage
                Seq:enqueue({
                    Banner:display(1, "victory", 300, function()
                        state.stage:advance(Stages, Screens, state)
                    end),
                })
            else
                -- show player 1 "defeat" banner for 300 frames, then show the "defeat" screen
                Seq:enqueue({
                    Banner:display(2, "defeat", 300, function()
                        state.screen = Screens.defeat
                    end),
                })
            end

            -- handle 2-player games
        else
            -- display the winning player's banner, then go to the title screen
            local msg = "player " .. victor .. " victory"
            Seq:enqueue({
                Banner:display(victor, msg, 300, function()
                    state.screen = Screens.title
                end),
            })
        end

        return
    end

    -- run the command loop
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

    -- draw units
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

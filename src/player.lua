Player = {battle = {}}

-- define the constructor
function Player:new(p)
  setmetatable(p, self)
  self.__index = self

  -- each player owns a cursor
  p.cursor = Cursor:new()

  return p
end

-- attack the enemy unit
function Player.attack(attacker, target, system, state)
  -- hide the attacker's radii
  attacker.radius.vis = false

  -- get the defensive modifier for the target's cell
  local def = Cell.datum(target.cellx, target.celly, 'def', state)

  -- NB: This "cloning" bit is confusing at a glance.
  -- The intention here is to allow the animations to play before showing
  -- their consequences. (Ex: don't remove ships from the swarm until after
  -- the laser has fired.)
  --
  -- We must know the outcome of the battle in order to enqueue the
  -- appropriate animations. That being the case, we're first attacking a
  -- clone of the target, determining the battle outcome, enqueing the
  -- appropriate animations, and then (lastly) harming the "real" target.
  --
  -- The following function simply encapsulates the process of inflicting
  -- damage on the targeted unit (or its clone), because that process must be
  -- executed twice.
  local clone, damage = Unit.clone(target), function(u, atk)
    return attacker:attack(u, system, atk, def, false, state)
  end

  -- determine if the target will be killed, and begin enqueing animations
  local killed = damage(clone, attacker.stat.atk)

  -- visrad: track all units with visible radii
  -- seqs: aggregate animations to enqueue
  local visrad, seqs = {}, {}

  -- stop shooting if there's nothing left
  local shots = attacker.stat.atk <= target:swarm() and attacker.stat.atk or
                  target:swarm()

  -- visrad: identify all units with visible radii, and temporarily hide their radii.
  -- (This makes the animation look cleaner.)
  for i, unit in ipairs(state.stage.units) do
    if unit.radius.vis then
      unit.radius.vis = false
      add(visrad, i)
    end
  end

  -- launch an attack (and apply damage to the attacker) for every point in
  -- the attacker's attack system
  for _ = 1, shots do
    add(seqs, Anim.laser(attacker, target))

    -- TODO: if terrain bonuses were multiplicative rather than additive
    -- (and thus commuted), we could do this, which would animate each ship
    -- being shot done in real-time!
    -- add(seqs, function()
    -- damage(target, 1)
    -- return true
    -- end)
  end

  -- kill the enemy unit if it was destroyed
  if killed then
    add(
      seqs, function()
        Units.die(target.id, state.stage.units)
      end
    )
    add(seqs, Anim.explode(target.pxx, target.pxy, state))
    add(seqs, Anim.delay(30))
  end

  -- XXX: this logic may become faulty when the AI is able to attack *before*
  -- it moves
  add(
    seqs, function()
      -- XXX: see TODO above
      damage(target, attacker.stat.atk)

      if not attacker.moved and attacker.stat.mov >= 1 then
        attacker.radius:update(attacker, state, state.player.num)

        -- restore all hidden enemy radii
        for _, i in ipairs(visrad) do
          state.stage.units[i].radius.vis = true
        end
      else
        state.player:turnEnd(state)
      end
    end
  )

  return seqs
end

-- return true if the current player is a human
function Player:human(players)
  return not players[self.num].cpu
end

-- change the player turn
function Player:turnEnd(state)
  local cam = state.camera

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
  Seq:enqueue(
    {
      Anim.delay(30),
      function()
        cam:focus(cur.cellx, cur.celly, state)
      end,
      Anim.trans(cam, cam.cellx, cam.celly),
    }
  )
end

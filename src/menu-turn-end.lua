Menus.TurnEnd = {choices = {"yes", "no"}, sel = 1, vis = false}

-- open the target menu
function Menus.TurnEnd:open(state)
    self.sel, state.menu = 1, self
end

-- update "end turn?" menu state
function Menus.TurnEnd:update(state, inputs)
    Info:set("confirm", "cancel")

    -- right
    if self.sel == 1 and btnp(1) then
        self.sel = 2

        -- left
    elseif self.sel == 2 and btnp(0) then
        self.sel = 1
    end

    -- selection: "yes"
    if inputs.yes:once() and self.sel == 1 then
        state.player:turn_end(state)
        state.menu = nil

        -- selection: "no"
    elseif inputs.no:once() or (inputs.yes:once() and self.sel == 2) then
        state.menu = nil
    end
end

-- draw the "end turn" menu
function Menus.TurnEnd:draw(state)
    -- offset the menu location to align with the camera
    local padx, pady = state.camera.px.x, state.camera.px.y

    -- draw the menu
    rectfill(42 + padx, 52 + pady, 86 + padx, 74 + pady, 0)
    print("end turn?", 47 + padx, 57 + pady, 7)

    -- highlight the selected option
    local yes, no = 10, 6
    if self.sel == 2 then yes, no = 6, 10 end

    -- print the options
    print("yes", 51 + padx, 65 + pady, yes)
    print("no", 67 + padx, 65 + pady, no)
end

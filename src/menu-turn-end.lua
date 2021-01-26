MenuTurnEnd = {choices = {"yes", "no"}, sel = 1, vis = false}

-- open the target menu
function MenuTurnEnd:open()
    self.sel = 1
    self.vis = true
end

-- update "end turn?" menu state
function MenuTurnEnd:update()
    -- right
    if self.sel == 1 and btnp(1) then
        self.sel = 2

        -- left
    elseif self.sel == 2 and btnp(0) then
        self.sel = 1
    end

    -- selection: "yes"
    if BtnYes:once() and self.sel == 1 then
        Turn:turn_end()
        self.vis = false

        -- selection: "no"
    elseif BtnNo:once() or (BtnYes:once() and self.sel == 2) then
        self.vis = false
    end
end

-- draw the "end turn" menu
function MenuTurnEnd:draw()
    -- exit early if the menu is not visible
    if not self.vis then return end

    -- offset the menu location to align with the camera
    local padx = Camera.px.x
    local pady = Camera.px.y

    -- draw the menu
    rectfill(42 + padx, 52 + pady, 86 + padx, 74 + pady, 0)
    print("end turn?", 47 + padx, 57 + pady, 7)

    -- highlight the selected option
    if self.sel == 1 then
        print("yes", 51 + padx, 65 + pady, 10)
        print("no", 67 + padx, 65 + pady, 6)
    else
        print("yes", 51 + padx, 65 + pady, 6)
        print("no", 67 + padx, 65 + pady, 10)
    end
end

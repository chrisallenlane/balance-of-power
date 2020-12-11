Screens.battle.menu = {choices = {"yes", "no"}, sel = 1, vis = false}

-- update "end turn?" menu state
function Screens.battle.menu:update()

    -- right
    if self.sel == 1 and btnp(1) then
        self.sel = 2

        -- left
    elseif self.sel == 2 and btnp(0) then
        self.sel = 1
    end

    -- selection: "yes"
    if btnp(5) and self.sel == 1 then
        Cursor:turn_end()
        self.vis = false

        -- selection: "no"
    elseif btnp(4) or (btnp(5) and self.sel == 2) then
        self.vis = false
    end
end

-- draw the "end turn" menu
function Screens.battle.menu:draw()
    if self.vis then
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
end

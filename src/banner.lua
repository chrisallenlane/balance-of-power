-- XXX: this is all horrible
-- TODO: actually animate the menu
-- TODO: clear the radii
-- TODO: freeze the player controls
-- TODO: play victory music
-- TODO: handle two-player games correctly
-- TODO: hide the info bar when the banner is displayed
Banner = {lose = false, vis = false, win = false}

function Banner.victory()
    return function()
        Banner.vis = true
        Banner.win = true
        return true
    end
end

function Banner.defeat()
    return function()
        Banner.vis = true
        Banner.lose = true
        return true
    end
end

function Banner:draw()
    if not self.vis then return end

    if self.win then
        rectfill(0, 45, 128, 70, 1)
        line(0, 46, 128, 46, 7)
        line(0, 47, 128, 47, 12)
        line(0, 68, 128, 68, 12)
        line(0, 69, 128, 69, 7)
        String.centerX("victory", 55, 7)
    else
        rectfill(0, 45, 128, 70, 2)
        line(0, 46, 128, 46, 7)
        line(0, 47, 128, 47, 8)
        line(0, 68, 128, 68, 8)
        line(0, 69, 128, 69, 7)
        String.centerX("defeat", 55, 7)
    end
end

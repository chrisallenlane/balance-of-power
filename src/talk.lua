Talk = {}

-- initialize a new talk box
function Talk:new()
    local t = {
        -- is the talk dialog visible?
        vis = false,
        page = 1,
        pages = {},
        said = "",
        frame = 0,
        color = 6,
    }
    setmetatable(t, self)
    self.__index = self
    return t
end

-- initialize a new `page` table
function Talk.newPage(line)
    local parts = split(line, "|")
    return {who = parts[1], text = parts[2]}
end

-- handle talk box inputs
function Talk:update(_, inputs)
    if inputs.yes:once() then
        -- if we've reached the last page, close the talk box
        if self.page == #self.pages then
            self.vis = false
            return
        end

        -- otherwise, turn the page
        self.said, self.page = "", self.page + 1
    end
end

-- type text into the talk box
function Talk:say(lines, state)
    -- don't display the talk dialog if so configured
    if state.optNoTalk then return end

    -- reset state
    self.page, self.frame, self.pages, self.said = 1, 0, {}, ""

    -- split the block of text into individual lines
    for i, line in ipairs(lines) do
        -- create a new page from each line
        self.pages[i] = self.newPage(line)
    end

    -- display the talk box
    self.vis = true
end

-- draw the talk box
function Talk:draw(state)
    if not self.vis then return end

    -- get the page and camera coordinates
    local page, x, y = self.pages[self.page], state.camera.pxx, state.camera.pxy

    -- draw the background box
    rectfill(0 + x, 91 + y, 127 + x, 127 + y, 0)

    -- draw the portrait
    sspr(page.who == "alice" and 64 or 96, 0, 32, 32, 2 + x, 94 + y)

    -- extract the substring
    if #self.said < #page.text then
        self.said = sub(page.text, 0, #self.said + 1)
    end

    -- print the dialog
    print(self.said, 38 + x, 95 + y, 7)

    -- print the "next" button
    self.frame = self.frame + 1
    if self.frame % 30 == 0 then self.color = self.color == 5 and 6 or 5 end
    print("\142", 119 + x, 121 + y, self.color)
end

Input = {}

-- Input constructor
function Input:new(btn)
    local i = {btn = btn}

    setmetatable(i, self)
    self.__index = self

    -- instance properties
    i.frame = 1
    i.wait = 8

    return i
end

-- Implement functionality similar to `btnp`, but with a shorter spin-up time
function Input:rep()
    -- if the button was not pressed, set the frame counter to `wait` minus 1.
    -- This ensures that a key press is registered when the key is initially
    -- pressed.
    if not btn(self.btn) then
        self.frame = self.wait - 1
        return false
    end

    -- increment the frame counter
    self.frame = self.frame + 1

    -- if we've waited long enough, reset the counter and return true
    if self.frame >= self.wait then
        self.frame = 1
        return true
    end

    return false
end

-- Initialize globals for reading button inputs
BtnLeft = Input:new(0)
BtnRight = Input:new(1)
BtnUp = Input:new(2)
BtnDown = Input:new(3)
BtnX = Input:new(5)
BtnZ = Input:new(4)

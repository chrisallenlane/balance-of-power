Menu = {}

-- Implement common menu choice-selection functionality
function Menu.select(self, inputs)
    if inputs.up:rep() and self.sel >= 2 then
        return self.sel - 1
    elseif inputs.down:rep() and self.sel <= #self.choices - 1 then
        return self.sel + 1
    end
    return self.sel
end

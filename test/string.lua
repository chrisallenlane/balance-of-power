require("../src/string")

describe("string", function()
    it("should print a centered string", function()
        -- mock the `print` method
        local pr = function(str, x, y, color)
            return str, x, y, color
        end

        -- run assertions on spied values
        local str, x, y, color = String.centerX("hello, world", 64, 1, pr)
        assert.equal("hello, world", str)
        assert.equal(40, x)
        assert.equal(64, y)
        assert.equal(1, color)
    end)
end)

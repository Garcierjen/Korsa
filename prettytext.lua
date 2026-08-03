-- [ filename: prettytext.lua                                         ]
-- [ An overcomplicated piece of styling code for your cli -garcierjen]

local m = {}
local colord = require("colord")

---wait in second
---@param t number
function m:wait(t)
    local start = os.clock()
    while os.clock() - start < t do end
end


--typewrite effect
---@param text string
---@param time number
function m:typewrite(text, time)
    local len = string.len(text)
    if len == 0 then return end
    local del = time / len
    for i = 1, len do
        local char = string.sub(text, i, i) 
        io.write(char)
        io.flush()
        m:wait(del)
    end
    io.flush()
end

--spinning loading from npm
---@param time number
function m:spinning(time)
    local frame = {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
    colord:cursorinvis()
    colord:cursaveposDEC()
    for i = 1,time do
        for _, v in ipairs(frame) do
            colord:curtosaveDEC()
            io.write(colord:eraseinline()..v)
            io.flush()
            m:wait(1 / 10)
        end
    end
    io.flush()
    colord:cursorvis()
end

return m
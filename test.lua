local useragent = require("useragent")

local f = useragent:getbrowser()

for i, v in ipairs(f) do
    print(i,v)
end
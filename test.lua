-- random draft will be here
local useragent = require("useragent")

local f = useragent:getbrowser()

for i, v in ipairs(f) do
    print(" \""..v.useragent.."\",")
end


local page = io.open("dostestweb.html","r")

print(page:read("*a"))

page:close()
print(math.random(1,256) - 1 .."."..math.random(1,256) - 1 .."."..math.random(1,256) - 1 .."."..math.random(1,256) - 1 ..":"..math.random(1,8999))

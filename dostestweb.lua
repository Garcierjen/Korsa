local app = require("milua")
local page = io.open("dostestweb.html","r")

if not page then print("no page") end

app.get(
    "/",
    function()
        return page:read("*a"), {
            ["Content-Type"] = "text/html"
        }
    end
)
app.start()
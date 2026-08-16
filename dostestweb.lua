local app = require("milua")

local pg = [[<h1>test ser for dos</h1>
<h1>test this pg with curl</h1>
]]

app.get(
    "/",
    function()
        return pg, {
            ["Content-Type"] = "text/html"
        }
    end
)
app.start()
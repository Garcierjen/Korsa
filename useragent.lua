-- [ note:                                          ]
-- [    this is ported from python user agent       ]
-- [    not directly                                ]
-- [ https://github.com/fake-useragent/fake-useragent]
-- [ FILENAME: useragent.lua                        ]

local m = {}
local json = require("json")

function m:getbrowser()
    local e = io.open("browser.jsonl", "r")
    if not e then return nil end
    local res = {}
    for line in e:lines() do
        if line ~= "" then
            local success, parsed = pcall(json.decode, line)
            if success then
                table.insert(res, parsed)
            end
        end
    end
    return res
end

return m

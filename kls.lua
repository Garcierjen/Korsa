-- [ note: This will get progessively more complex and WILL make alot of technical dev ]
-- [       so please refactor every month or two. -garcierjen                          ]
-- [       kls.lua                                                                     ]

local config_content = [[
-- [ note: config for kls -garcierjen ]
-- [ AUTO GENERATED                   ]
-- [ filename: config.lua             ] 
-- DO NOT OBFUSCATE OR COMPILE TO LUAC

local m = {}

m.defaultmode = 1 -- [ note: 1 for cli, 2 for tui ]

m.ESC = "Hexadecimal" -- [ note: On different OS have their own ANSI Escape can be change to ]
                      -- [ "Octal", "Ctrl-Key", "Unicode", "Hexadecimal", "Decimal"          ]
                      -- ANSI Escape Sequences doc : https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
                      -- on unix can be check via echo $COLORTERM or just env and scroll
                      -- edit if weird
            
return m
]]

local config

local function file_exists(path)
    local f = io.open(path, "r")
    if f then 
        f:close() 
        return true 
    end
    return false
end

if file_exists("config.lua") then
    config = require("config")
else
    print("Config file does not exist. Creating a new one...")
    local file, err = io.open("config.lua", "w")
    if file then
        file:write(config_content)
        file:close()
        config = dofile("config.lua") 
    else
        print("Error creating config file: " .. tostring(err))
    end
end

local colord = require("colord")
local prettytext = require("prettytext")
local socket = require('socket')
local branding = [[
                   _                                     
          ' )   _/                               
          /' _/~                                 
        /'_/~    ____     ____     ____     ____ 
      /\/~     /'    )--)'    )--/'    )--/'    )
    /'  \    /'    /' /'        '---,   /'    /' 
(,/'     \_,(___,/' /'        (___,/   (___,/(__                                                  
]]


local function warn(text)
    io.write(colord:bit16setcolor("default","default","graphic","bold"))
    io.write(colord:b256setcolor(130,"fg").."Warning : "..colord:reset()..tostring(text))
    io.flush()
end

local function tdos()
    colord:reset()
    colord:erasesavedL()
    colord:eraseall()
    io.write(colord:cursorinvis())
    io.write("Target : ")
    local input = io.read()
end

local function exit() -- exit and clean up
    colord:reset()
    colord:erasesavedL()
    colord:eraseall()
    io.write(colord:cursorvis())
    os.exit()
end

local tchoice = {
    dos = "DoS attack the request url",
    exit = "exit"
}

local justrun = {
        dos = {
            run = function() tdos() end
        },
        exit = {
            run = function() exit() end
        }
    }

local function cli()
    print("cli")
end

local function tui()
    while true do
        io.write("\n")
        colord:reset()
        colord:erasesavedL()
        colord:eraseall()
        io.write(colord:cursorinvis())
        io.write(colord:b256setcolor(211,"fg")..branding..colord:reset())
        io.flush()
        io.write("Tools:\n")
        local count = 1 --dynamically count choice (this is stupid)
        local idn = {} -- this would dynamically list choice
        for i, v in pairs(tchoice) do --choice (tui)
            io.write(string.format("    "..colord:b256setcolor(221,"fg").."%d."..colord:b256setcolor(223,"fg").."%s   "..colord:reset().."-"..colord:b256setcolor(226,"fg").."   %s\n"..colord:reset(),count,i,v))
            count = count + 1
            table.insert(idn,i)
        end
        local input = io.read()
        if tonumber(input) == nil then
            warn("numbers please.\n")
        elseif tonumber(input) > count then
            warn("out of range.\n")
        elseif tonumber(input) == 0 then
            warn("the list start with 1")
        else
            justrun[idn[tonumber(input)]].run()
        end
    end
end

local function main()
    if config.defaultmode == 1 then
        warn("mode = cli")
        cli()
    elseif config.defaultmode == 2 then
        warn("mode = tui")
        tui()
    end
    return 0
end

main()
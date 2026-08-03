-- [ note: This is for Terminal manipulating all in one module     ]
-- [       and also this is pretty bloated considered rewrite      ]
-- [       your own version only with function you need            ]
-- [ support: Originally written for unix or unix-like OS, but     ]
-- [          can be port to other OS.                             ]
-- [                                                               ]
-- [ filename: colord.lua                                          ]
-- this is just aliasing stuff
-- [ more info: https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b ]

local m = {}
local config = require("config")
local ESC

-- set esc

if config.ESC == "Hexadecimal" then
    ESC = "\x1B"
elseif config.ESC == "Octal" then
    ESC = "\033"
elseif config.ESC == "Unicode" then
    ESC = [[\u001b]]
elseif config.ESC == "Ctrl-Key" then
    ESC = "^["
elseif config.ESC == "Decimal" then
    ESC = "27"
end

--#region private voids

--reserve for future use

--#endregion private voids

--#region public voids
-- Cursor Controls

function m:cursorsethome()
    io.write(ESC.."[H")
    io.flush()
end

function m:cursortoLtoCH(Line, Column)
    io.write(ESC..'['..Line..';'..Column..'H')
    io.flush()
end

function m:cursortoLtoCF(Line, Column)
    io.write(ESC..'['..Line..';'..Column..'f')
    io.flush()
end

function m:cursorup(Line)
    io.write(ESC..'['..Line..'A')
    io.flush()
end

function m:cursordown(Line)
    io.write(ESC..'['..Line..'B')
    io.flush()
end

function m:cursorright(Column)
    io.write(ESC..'['..Column..'C')
    io.flush()
end

function m:cursorleft(Column)
    io.write(ESC..'['..Column..'D')
    io.flush()
end

function m:cursorbegN(Line)
    io.write(ESC..'['..Line..'E')
    io.flush()
end

function m:cursorbegP(Line)
    io.write(ESC..'['..Line..'F')
    io.flush()
end

function m:cursortoCol(Column)
    io.write(ESC..'['..Column..'G')
    io.flush()
end

function m:cursorlineup()
    io.write(ESC.."M")
    io.flush()
end

function m:cursaveposDEC()
    io.write(ESC.."7")
    io.flush()
end

function m:curtosaveDEC()
    io.write(ESC.."8")
    io.flush()
end

function m:cursaveposSCO()
    io.write(ESC.."[s")
    io.flush()
end

function m:curtosaveSCO()
    io.write(ESC.."[u")
    io.flush()
end

--[[ 
    note: Some sequences, like saving and restoring cursors, are private sequences and are not standardized. 
          While some terminal emulators (i.e. xterm and derived) support both SCO and DEC sequences, 
          they are likely to have different functionality. It is therefore recommended to use DEC sequences.
--]]

-- Erase Functions

function m:eraseindis()
    io.write(ESC.."[J")
    io.flush()
end

function m:erasecurbeg()
    io.write(ESC.."[1J")
    io.flush()
end

function m:eraseall()
    io.write(ESC.."[2J")
    io.flush()
end

function m:erasesavedL()
    io.write(ESC.."[3J")
    io.flush()
end

---@return any
function m:eraseinline()
    return ESC.."[K"
end

---@return any
function m:erasestartline()
    return ESC.."[1K"
end

---@return any
function m:eraseentireline()
    return ESC.."[2K"
end

--[[
    note: Erasing the line won't move the cursor, meaning that the cursor will
          stay at the last position it was at before the line was erased. 
          You can use \r after erasing the line, to return the cursor to the start of the current line.
--]]

-- 16 bit coloring

-- reset all color and mode
---@return string
function m:reset()
    return ESC.."[0m"
end

-- 16 bit set color note: this can be use as graphic mode for styling like italic
---@param colorfg string
---@param colorbg string
---@param mode string
---@param gmode string
---@return string?
function m:bit16setcolor(colorfg, colorbg, mode, gmode)
    local validcolorfg = {
        black = 30, red = 31, green = 32, yellow = 33,
        blue = 34, magenta = 35, cyan = 36, white = 37,
        default = 39, reset = 0
    }
    local validcolorbg = {
        black = 40, red = 41, green = 42, yellow = 43,
        blue = 44, magenta = 45, cyan = 46, white = 47,
        default = 49, reset = 0
    }
    local validgmode = {
        normal = 0, bold = 1, dim = 2, italic = 3,
        underline = 4, blink = 5, reverse = 7, hidden = 8,
        strikethrough = 9
    }
    local fg_code = validcolorfg[colorfg] or validcolorfg.Default
    local bg_code = validcolorbg[colorbg] or validcolorbg.Default
    local g_code = validgmode[gmode] or validgmode.normal
    if mode == "fg" then
        return ESC.."["..g_code..";"..fg_code.."m"
    elseif mode == "bg" then
        return ESC.."["..g_code..";"..bg_code.."m"
    elseif mode == "both" then
        return ESC.."["..g_code..";"..fg_code..";"..bg_code.."m"
    elseif mode == "graphic" then
        return ESC.."["..g_code.."m"
    elseif mode == "none" then
        io.write('colord:bit16setcolor() : "why?"\n')
        io.flush()
    end
    return nil
end

-- note: fg and bg are seperated unlike 16 bit coloring the usage would be like colord:b256setcolor(234,fg) colord:b256setcolor(241,bg)
function m:b256setcolor(color, mode)
    if mode == "fg" and color <= 255 then
        return ESC.."[38;5;"..color.."m"
    elseif mode == "bg" and color <= 255 then
        return ESC.."[48;5;"..color.."m"
    end
end

function m:rgbsetcolor(r, g, b, mode)
    if mode == "fg" and r <= 255 and g <= 255 and b <= 255 then
        return ESC.."[38;2;"..r..";"..g..";"..b.."m"
    elseif mode == "bg" and r <= 255 and g <= 255 and b <= 255 then
        return ESC.."[48;2;"..r..";"..g..";"..b.."m"
    end
end

-- note: skip screen mode bc not much use case
-- Common Private Modes

function m:cursorinvis()
    io.write(ESC.."[?25l")
    io.flush()
end

function m:cursorvis()
    io.write(ESC.."[?25h")
    io.flush()
end

function m:restorescreen()
    io.write(ESC.."[?47l")
    io.flush()
end

function m:savescreen()
    io.write(ESC.."[?47h")
    io.flush()
end

function m:enablealtbuff()
    io.write(ESC.."[?1049h")
    io.flush()
end

function m:disablealtbuff()
    io.write(ESC.."[?1049l")
    io.flush()
end

--#endregion public voids

return m
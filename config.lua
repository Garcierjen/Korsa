-- [ note: config for kls -garcierjen ]
-- [ AUTO GENERATED                   ]
-- [ filename: config.lua             ] 
-- DO NOT OBFUSCATE OR COMPILE TO LUAC

local m = {}

m.defaultmode = 2 -- [ note: 1 for cli, 2 for tui ]

m.ESC = "Hexadecimal" -- [ note: On different OS have their own ANSI Escape can be change to ]
                      -- [ "Octal", "Ctrl-Key", "Unicode", "Hexadecimal", "Decimal"          ]
                      -- ANSI Escape Sequences doc : https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
                      -- on unix can be check via echo $COLORTERM or just env and scroll
                      -- edit if weird
            
return m

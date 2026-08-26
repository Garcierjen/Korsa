# Korsa
A Multi-tools written in lua with [Kls](https://github.com/Garcierjen/kls "Kls on Github").
Written for basic pentesting.

- **Warning** : This is written for educational purpose and not for any illegal uses (The author is not liable for any damage done using this tools and do not encourage unethical use.)

## Project file structure  :

```bash
$ ls
colord.lua  dostestweb.html config.lua (auto-generate)  dostestweb.lua   prettytext.lua
deps.txt    kls.lua         proxies.lua (auto-generate)     useragent.lua
```

## Dependencies  :

- **Lua** : Tested on lua5.4 but other version should be fine.

- **Installation** : I recommended installing modules with [Luarocks](https://luarocks.org) or compile from source

- **Modules** : [luasocket](https://github.com/lunarmodules/luasocket), [lanes](https://github.com/LuaLanes/lanes), [milua](https://github.com/MiguelMJ/Milua) (Optional)

## Proxies  :

- **Proxies** : Proxies file should look like this.

```bash
$ cat proxies.txt
56.189.63.182:5851
15.164.145.180:2902
165.45.113.69:4440
24.181.18.31:2924
77.228.86.84:5957
ip:port
...
```

## Binary Compiling  :

- This can be done using srlua but luaot is also a great alternative
- For Makefile it require luacc for bundling

- **Lang use:**
  [![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)

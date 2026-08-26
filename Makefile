CC = luacc #from luarocks
LUAC = luac
out = korsa

all:
	$(CC) kls -o kls.o -i useragent colord prettytext
	$(LUAC) -o korsa kls.o

clean:
	rm -rf kls.o

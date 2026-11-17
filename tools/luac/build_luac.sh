#!/bin/sh
# Build a luac that writes EdgeTX bytecode: Lua 5.3.6 with 32-bit integers and
# floats (LUA_32BITS) and a 32-bit size_t in the dump (ldump-edgetx.patch).
# Output: tools/luac/luac-edgetx
set -e
cd "$(dirname "$0")"
work=$(mktemp -d)
curl -sL -o "$work/lua.tar.gz" https://www.lua.org/ftp/lua-5.3.6.tar.gz
tar xzf "$work/lua.tar.gz" -C "$work"
(cd "$work/lua-5.3.6" && patch -p1 < "$OLDPWD/ldump-edgetx.patch")
make -C "$work/lua-5.3.6/src" luac MYCFLAGS="-DLUA_32BITS -DLUA_USE_LINUX" >/dev/null
cp "$work/lua-5.3.6/src/luac" luac-edgetx
rm -rf "$work"
echo "built tools/luac/luac-edgetx"

#!/bin/sh
# Compile the files changed for xTelemetry into the SD card tree under SD/.
# The other .luac files in SD/ are the unmodified upstream release builds.
# Copy SD/ onto the radio's SD card.
set -e
cd "$(dirname "$0")"
LUAC=tools/luac/luac-edgetx
[ -x "$LUAC" ] || tools/luac/build_luac.sh
"$LUAC" -s -o SD/SCRIPTS/TELEMETRY/yaapu7.luac src/yaapu7.lua
for f in menu7 right7; do
  "$LUAC" -s -o "SD/SCRIPTS/TELEMETRY/yaapu/$f.luac" "src/Yaapu/$f.lua"
done
echo "SD/ updated"

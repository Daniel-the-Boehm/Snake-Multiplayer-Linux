#!/bin/sh
set -eu

DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

rm -f "$HOME/.local/bin/snake-multiplayer"
rm -f "$DATA/applications/snake-multiplayer.desktop"
rm -f "$DATA/icons/hicolor/256x256/apps/snake-multiplayer.png"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$DATA/applications" >/dev/null 2>&1 || true
fi

echo "Snake is removed. Settings and high scores are still in $DATA/snake"

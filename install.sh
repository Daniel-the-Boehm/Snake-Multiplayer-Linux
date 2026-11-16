#!/bin/sh
set -eu

REPO="Daniel-the-Boehm/Snake-Multiplayer-Linux"
ARCH="$(uname -m)"
ASSET="Snake-linux-$ARCH.tar.gz"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
BIN_DIR="$HOME/.local/bin"
TMP=""

cleanup() {
    if [ -n "$TMP" ]; then
        rm -rf "$TMP"
    fi
}
trap cleanup EXIT

SRC="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"

if [ ! -f "$SRC/snake-multiplayer" ] || [ ! -f "$SRC/snake-multiplayer.png" ]; then
    if [ "$ARCH" != "x86_64" ]; then
        echo "There is no ready-made download for $ARCH. Build it yourself with build_linux.sh."
        exit 1
    fi
    URL="https://github.com/$REPO/releases/latest/download/$ASSET"
    TMP="$(mktemp -d)"
    echo "Downloading Snake..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$URL" -o "$TMP/$ASSET"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$URL" -O "$TMP/$ASSET"
    else
        echo "Neither curl nor wget is installed. Install one of them and try again."
        exit 1
    fi
    tar -xzf "$TMP/$ASSET" -C "$TMP"
    SRC="$TMP/Snake-linux-$ARCH"
fi

mkdir -p "$BIN_DIR" "$DATA/applications" "$DATA/icons/hicolor/256x256/apps"
cp "$SRC/snake-multiplayer" "$BIN_DIR/snake-multiplayer"
chmod 755 "$BIN_DIR/snake-multiplayer"
cp "$SRC/snake-multiplayer.png" "$DATA/icons/hicolor/256x256/apps/snake-multiplayer.png"

cat >"$DATA/applications/snake-multiplayer.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Snake
GenericName=Snake Multiplayer
Comment=Snake with seven game modes and local multiplayer
Exec="$BIN_DIR/snake-multiplayer"
Icon=snake-multiplayer
Terminal=false
Categories=Game;ArcadeGame;
Keywords=snake;multiplayer;arcade;
StartupWMClass=snake-multiplayer
DESKTOP

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$DATA/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -q -t "$DATA/icons/hicolor" >/dev/null 2>&1 || true
fi

echo "Snake is installed. Open it from the application menu or run:"
echo "    $BIN_DIR/snake-multiplayer"

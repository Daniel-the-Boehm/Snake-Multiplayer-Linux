#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

VERSION="${1:-1.0.0}"
VERSION="${VERSION#v}"
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) DEB_ARCH="amd64" ;;
    aarch64) DEB_ARCH="arm64" ;;
    *) DEB_ARCH="$ARCH" ;;
esac
NAME="Snake-linux-$ARCH"

echo "=== Snake: build $NAME.tar.gz and snake-multiplayer_$DEB_ARCH.deb (version $VERSION) ==="

rm -rf build dist
mkdir -p build dist

if command -v uv >/dev/null 2>&1; then
    uv venv --quiet --python 3.13 --python-preference only-managed build/venv
    uv pip install --quiet --python build/venv/bin/python -r requirements.txt pyinstaller
else
    if ! command -v python3 >/dev/null 2>&1; then
        echo "python3 not found. Install Python 3.12 or 3.13 first."
        exit 1
    fi
    python3 -m venv build/venv
    build/venv/bin/python -m pip install --quiet --upgrade pip
    build/venv/bin/python -m pip install --quiet -r requirements.txt pyinstaller
fi

PYGAME_HIDE_SUPPORT_PROMPT=1 build/venv/bin/python -c "import pygame; print('pygame', pygame.version.ver, 'OK')"

echo "Compiling..."
build/venv/bin/python -m PyInstaller --noconfirm --clean \
    --distpath build/bin --workpath build/work \
    packaging/snake-multiplayer.spec >build/pyinstaller.log 2>&1 || {
    tail -30 build/pyinstaller.log
    echo "Build failed. Full log: build/pyinstaller.log"
    exit 1
}

echo "Creating $NAME.tar.gz..."
STAGE="build/$NAME"
mkdir -p "$STAGE"
install -m 755 build/bin/snake-multiplayer "$STAGE/snake-multiplayer"
install -m 755 install.sh uninstall.sh "$STAGE/"
install -m 644 snake.png "$STAGE/snake-multiplayer.png"
install -m 644 packaging/snake-multiplayer.desktop packaging/README.txt LICENSE "$STAGE/"
tar -C build --owner=0 --group=0 -czf "dist/$NAME.tar.gz" "$NAME"

if command -v dpkg-deb >/dev/null 2>&1; then
    echo "Creating snake-multiplayer_$DEB_ARCH.deb..."
    PKG="build/deb"
    mkdir -p "$PKG/DEBIAN" "$PKG/usr/bin" "$PKG/usr/share/applications" \
        "$PKG/usr/share/icons/hicolor/256x256/apps" "$PKG/usr/share/doc/snake-multiplayer"
    install -m 755 build/bin/snake-multiplayer "$PKG/usr/bin/snake-multiplayer"
    install -m 644 packaging/snake-multiplayer.desktop "$PKG/usr/share/applications/"
    install -m 644 snake.png "$PKG/usr/share/icons/hicolor/256x256/apps/snake-multiplayer.png"
    install -m 644 LICENSE "$PKG/usr/share/doc/snake-multiplayer/copyright"
    SIZE="$(du -sk "$PKG/usr" | cut -f1)"
    cat >"$PKG/DEBIAN/control" <<CONTROL
Package: snake-multiplayer
Version: $VERSION
Architecture: $DEB_ARCH
Maintainer: Daniel-the-Boehm <noreply@github.com>
Installed-Size: $SIZE
Depends: libc6
Section: games
Priority: optional
Homepage: https://github.com/Daniel-the-Boehm/Snake-Multiplayer-Linux
Description: Snake with seven game modes and local multiplayer
 Plays alone or with up to four people on the same network.
 Compatible with the Windows and macOS versions.
CONTROL
    dpkg-deb --root-owner-group --build "$PKG" "dist/snake-multiplayer_$DEB_ARCH.deb" >/dev/null
else
    echo "dpkg-deb not found, skipping the .deb package."
fi

echo
echo "Done!"
ls -lh dist

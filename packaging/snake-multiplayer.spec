from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all("pygame")

a = Analysis(
    ["../snake.py"],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    excludes=["tkinter"],
)

SYSTEM_LIBS = (
    "libX11.so", "libXau.so", "libXdmcp.so", "libxcb.so", "libbsd.so", "libmd.so",
    "libglib-2.0.so", "libgthread-2.0.so", "libpcre2-8.so",
    "libstdc++.so", "libgcc_s.so", "libz.so",
)
a.binaries = [b for b in a.binaries if not b[0].startswith(SYSTEM_LIBS)]

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    name="snake-multiplayer",
    console=False,
    upx=False,
)

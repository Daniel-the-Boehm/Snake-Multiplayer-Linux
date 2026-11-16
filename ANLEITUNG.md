# Snake für Linux – Installation

Das Spiel braucht kein Python und keine zusätzlichen Pakete. Es läuft auf 64-Bit-PCs mit Intel- oder AMD-Prozessor (x86_64).

Alle Downloads: <https://github.com/Daniel-the-Boehm/Snake-Multiplayer-Linux/releases/latest>

---

## Weg 1: Ein Befehl (jede Distribution)

1. Terminal öffnen (meist `Strg` + `Alt` + `T`).
2. Diese Zeile einfügen und Enter drücken:

   ```
   curl -fsSL https://raw.githubusercontent.com/Daniel-the-Boehm/Snake-Multiplayer-Linux/main/install.sh | sh
   ```

3. Snake im Anwendungsmenü suchen und starten.

Es wird kein Passwort gebraucht. Das Spiel landet in `~/.local/bin`.

---

## Weg 2: .deb-Paket (Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin)

1. `snake-multiplayer_amd64.deb` herunterladen.
2. Doppelklick auf die Datei und auf **Installieren** klicken.
3. Snake im Anwendungsmenü suchen und starten.

Falls der Doppelklick nichts öffnet, im Download-Ordner ein Terminal öffnen:

```
sudo apt install ./snake-multiplayer_amd64.deb
```

---

## Weg 3: Ohne Installation

1. `Snake-linux-x86_64.tar.gz` herunterladen.
2. Rechtsklick auf die Datei → **Hier entpacken**.
3. Im Ordner `Snake-linux-x86_64` doppelt auf `snake-multiplayer` klicken.

Wer danach doch einen Eintrag im Anwendungsmenü will: im Ordner ein Terminal öffnen und `./install.sh` ausführen.

---

## Deinstallieren

| Installiert mit | Befehl |
|---|---|
| Weg 1 oder `install.sh` | `curl -fsSL https://raw.githubusercontent.com/Daniel-the-Boehm/Snake-Multiplayer-Linux/main/uninstall.sh \| sh` |
| .deb-Paket | `sudo apt remove snake-multiplayer` |

Einstellungen und Highscores bleiben in `~/.local/share/snake` erhalten.

---

## Probleme

| Problem | Lösung |
|---|---|
| Doppelklick auf `snake-multiplayer` öffnet nichts | Rechtsklick → Eigenschaften → Zugriffsrechte → „Als Programm ausführen“ aktivieren. Oder im Terminal: `chmod +x snake-multiplayer` |
| Snake erscheint nach Weg 1 nicht im Menü | Einmal ab- und wieder anmelden. |
| Andere Spieler finden den Host nicht | Alle müssen im selben WLAN sein, kein Gastnetz. Sonst die IP-Adresse des Hosts im Join-Bildschirm eintippen. |
| Beitreten klappt auf Fedora oder openSUSE nicht | Die Firewall blockiert die Ports. Im Terminal: `sudo firewall-cmd --permanent --add-port=55055/tcp --add-port=55056/udp` und danach `sudo firewall-cmd --reload` |
| Das Spiel stürzt ab | Die Fehlermeldung steht in `~/.local/share/snake/snake_error.log`. |

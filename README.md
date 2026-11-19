# wxscreensaver

**Wayland-compatible replacement for the XScreenSaver daemon.** It runs the original
XScreenSaver hacks (screensavers) with its own daemon and a GTK3 settings GUI.
The original `xscreensaver` daemon is *not* started – only its hacks are used.
*(Early version, Arch Linux only for now. Hungarian documentation below.)*

---

Az xscreensaver Waylanden is működő pótlása. Az eredeti xscreensaver képernyőkímélőit
(hackjeit) futtatja, de a saját daemonjával és beállító felületével. Az eredeti
`xscreensaver` daemon **nem** indul el, csak a hackjeit használjuk.

> **Állapot:** korai verzió. GNOME + NVIDIA + Arch Linux alatt készült, más környezetben
> még kevéssé tesztelt. Hibajelentést szívesen fogadok (lásd lent).
> Nem hivatalos projekt, nincs kapcsolatban az XScreenSaverrel és szerzőjével.

## Telepítés (Arch Linux)

### A) Csomagként (ajánlott)

```bash
git clone https://github.com/pbalee/wxscreensaver
cd wxscreensaver
makepkg -si
```

A `makepkg` megépíti a csomagot, az `-s` feltelepíti a függőségeket (`python-gobject`, `gtk3`,
`xscreensaver`, `xorg-xwayland`), az `-i` pedig a `pacman`-nel telepíti. A daemon a következő
bejelentkezéskor magától elindul (`/etc/xdg/autostart`). GNOME-on kívül kell hozzá a `swayidle` is
(`sudo pacman -S swayidle`).

Eltávolítás: `sudo pacman -Rns wxscreensaver` (a `~/.config/wxscreensaver` megmarad, kézzel törölhető).
Frissítés: `git pull && makepkg -si`.

### B) Telepítő szkripttel

```bash
git clone https://github.com/pbalee/wxscreensaver
cd wxscreensaver
chmod +x install.sh wxscreensaver
./install.sh
```

Ne használd egyszerre a kettőt. Ha az egyiket a másikra cseréled, előbb távolítsd el az előzőt.

A telepítő sudo jelszót kér, majd:
- `pacman`-nel feltelepíti a függőségeket: `python-gobject`, `gtk3`, `swayidle`, `xscreensaver`
  (az xscreensaver csak a hackek miatt kell);
- bemásolja a programot a `/usr/local/bin` mappába;
- beállítja az automatikus indítást bejelentkezéskor;
- letiltja az eredeti xscreensaver szolgáltatást és autostartot;
- elindítja a daemont.

Beállítások megnyitása: `wxscreensaver` (vagy a menüben a *wxscreensaver* bejegyzés).

## Eltávolítás / frissítés (telepítő szkript esetén)

```bash
./uninstall.sh                  # mindent töröl (program, indítók, beállítások, cache)
./uninstall.sh --keep-config    # a beállításokat megtartja (frissítéshez ezt használd)
./uninstall.sh --remove-xscreensaver   # az eredeti xscreensaver csomagot is törli
```

Frissítés: `git pull`, majd `./uninstall.sh --keep-config` és `./install.sh`.

## Használat

| Parancs | Mit csinál |
|---|---|
| `wxscreensaver` | beállító GUI (hacklista, előnézet, opciók) |
| `wxscreensaver --daemon` | háttérszolgáltatás |
| `wxscreensaver --activate` / `--deactivate` | indítás / leállítás kézzel |
| `wxscreensaver --lock` | zároló parancs futtatása |
| `wxscreensaver --status` / `--reload` / `--quit` | állapot / újratöltés / leállítás |

Beállítások: `~/.config/wxscreensaver/config.json` (a GUI menti).

## Hogyan működik

- **Tétlenség-érzékelés:** `swayidle` (ext-idle-notify-v1: sway, Hyprland, labwc, KDE, …);
  GNOME alatt a Mutter IdleMonitor D-Bus API.
- **Megjelenítés:** monitoronként teljes képernyős GTK3 ablak Xwaylanden; a hackek
  `-window-id`-vel ebbe rajzolnak.
- **Inhibit:** a daemon `org.freedesktop.ScreenSaver` szolgáltatást nyújt, így a
  böngészők és videólejátszók megakadályozhatják az indulást. GNOME-on az
  `org.gnome.SessionManager` jelzését figyeli.
- **Opciók:** a hackek `/usr/share/xscreensaver/config/*.xml` leírásaiból generált
  csúszkák, jelölőnégyzetek és választók.
- **Módok:** kikapcsolva / csak üres képernyő / véletlenszerű (kipipálható hacklistával) /
  csak egy kijelölt hack.

## OpenGL (GL) hackek

Az új xscreensaver a GL hackekhez EGL-t használ, ami egyes rendszereken (pl. NVIDIA +
Xwayland) hibával leáll (`eglCreatePlatformWindowSurface failed`). Ezért a program
**automatikusan átvált**, ha egy hack EGL/GLX hibával azonnal kilép:

1. rendszer-driver (pl. NVIDIA),
2. Mesa Zink (Mesa a GPU Vulkan-ján keresztül, ehhez kellhet a `vulkan-nvidia`/`mesa`),
3. Mesa szoftveres renderelés (llvmpipe, lassabb, de működnie kell).

Az éppen működő szintet megjegyzi (`~/.cache/wxscreensaver/gl_level`). A *Beállítások →
OpenGL driver* listában kézzel is választhatsz.

## Korlátok

- **Zárolás:** egy X11 ablak Waylanden nem tud biztonságosan zárolni. A zárolást a megadott
  parancs végzi (alapból `loginctl lock-session`; írd át `swaylock`/`hyprlock`/`gtklock`
  stb.-re). Ez még nincs alaposan tesztelve.
- **Xwayland kell hozzá.** Magas DPI-n a rajz nem éles.
- **Több monitor:** monitoronként külön ablak nyílik; az elhelyezés compositorfüggő.
- Az ablak a compositor „fullscreen" rétegében van, így layer-shell panelek (pl. waybar)
  egyes compositorokon fölé rajzolhatnak.

## Hibajelentés

Kérlek a hibabejelentésben add meg:
- a distrót, a compositort / asztali környezetet és a videókártyát,
- a `WXSS_DEBUG=1 wxscreensaver --daemon` kimenetét,
- az érintett hack naplóját: `~/.cache/wxscreensaver/<hack neve>.log`,
- GL hackeknél a `~/.cache/wxscreensaver/gl_level` tartalmát és a `glxinfo -B | head -20` kimenetét.

## Licenc

MIT, lásd a [LICENSE](LICENSE) fájlt. Az XScreenSaver hackjei nincsenek a repóban,
azok az `xscreensaver` csomag részei és a saját licencük vonatkozik rájuk.

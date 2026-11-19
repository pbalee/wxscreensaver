# wxscreensaver

Az xscreensaver Wayland-kompatibilis pótlása. Az eredeti xscreensaver
képernyőkímélőit (hackjeit) futtatja, de a saját daemonjával és GUI-jával –
az eredeti `xscreensaver` daemon **nem** indul el.

## Telepítés (Arch Linux)

```bash
chmod +x install.sh wxscreensaver
./install.sh
```

A telepítő feltelepíti a függőségeket (`python-gobject gtk3 swayidle xscreensaver`),
bemásolja a programot `/usr/local/bin`-be, beállítja az automatikus indítást,
és letiltja az eredeti xscreensaver szolgáltatást/autostartot.

## Használat

| Parancs | Mit csinál |
|---|---|
| `wxscreensaver` | beállító GUI (hacklista, előnézet, opciók) |
| `wxscreensaver --daemon` | háttérszolgáltatás |
| `wxscreensaver --activate` / `--deactivate` | indítás / leállítás kézzel |
| `wxscreensaver --lock` | zároló parancs futtatása |
| `wxscreensaver --status` / `--reload` / `--quit` | állapot / újratöltés / leállítás |

Konfiguráció: `~/.config/wxscreensaver/config.json` (a GUI menti).
Hibakereséshez: `WXSS_DEBUG=1 wxscreensaver --daemon`.

## Hogyan működik

- **Tétlenség-érzékelés:** `swayidle` (ext-idle-notify-v1: sway, Hyprland, labwc, KDE, …),
  GNOME alatt a Mutter IdleMonitor D-Bus API.
- **Megjelenítés:** minden monitoron teljes képernyős GTK3 ablak Xwaylanden;
  a hackek `-window-id`-vel ebbe rajzolnak (ugyanígy fut az xscreensaver előnézete is).
- **Inhibit:** a daemon `org.freedesktop.ScreenSaver` szolgáltatást is nyújt, így a
  böngészők/videólejátszók megakadályozhatják az indulást.
- **Opciók:** a hackek `/usr/share/xscreensaver/config/*.xml` leírásaiból generálja
  a GUI csúszkáit, jelölőnégyzeteit és választóit.

## Korlátok

- **Zárolás:** egy X11 ablak Waylanden nem tud biztonságosan zárolni. A zárolást a
  megadott parancs végzi (alapból `loginctl lock-session`; írd át `swaylock`/`hyprlock`/
  `gtklock` stb.-re, ha nincs, ami a lock-session jelzésre figyel).
- **Xwayland kell hozzá.** Magas DPI-n a rajz nem éles.
- **Több monitor:** monitoronként külön ablak nyílik; az elhelyezés compositorfüggő.
- Az ablak a compositor „fullscreen” rétegében van, így layer-shell panelek (pl. waybar)
  egyes compositorokon fölé rajzolhatnak.

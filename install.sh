#!/usr/bin/env bash
# wxscreensaver telepítő (Arch Linux)
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Csomagok telepítése"
sudo pacman -S --needed --noconfirm python python-gobject gtk3 swayidle xscreensaver

echo "==> wxscreensaver telepítése"
sudo install -Dm755 wxscreensaver /usr/local/bin/wxscreensaver
mkdir -p "$HOME/.config/autostart" "$HOME/.local/share/applications"

cat > "$HOME/.local/share/applications/wxscreensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=wxscreensaver
Comment=Screensaver settings for Wayland
Exec=/usr/local/bin/wxscreensaver --settings
Icon=preferences-desktop-screensaver
Categories=Settings;DesktopSettings;
EOF

cat > "$HOME/.config/autostart/wxscreensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=wxscreensaver
Exec=/usr/local/bin/wxscreensaver --daemon
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF

echo "==> Az eredeti xscreensaver szolgáltatás letiltása (a hackek maradnak)"
pkill -x xscreensaver 2>/dev/null || true
systemctl --user disable --now xscreensaver.service 2>/dev/null || true
systemctl --user mask xscreensaver.service 2>/dev/null || true
cat > "$HOME/.config/autostart/xscreensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=XScreenSaver
Exec=xscreensaver -no-splash
Hidden=true
EOF

echo "==> Daemon indítása"
if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] && { [ -n "${WAYLAND_DISPLAY:-}" ] || [ -n "${DISPLAY:-}" ]; }; then
    setsid -f /usr/local/bin/wxscreensaver --daemon >/dev/null 2>&1 || true
    sleep 1
    /usr/local/bin/wxscreensaver --status \
        || echo "A daemon nem indult el; próbáld: WXSS_DEBUG=1 wxscreensaver --daemon"
else
    echo "Nincs grafikus session (D-Bus/DISPLAY/WAYLAND_DISPLAY hiányzik) – a daemon a következő bejelentkezéskor indul."
fi

echo
echo "Kész. Beállítások: wxscreensaver"
echo "Ha a compositorod nem futtatja az XDG autostartot, add a konfigjához:"
echo "  sway:      exec wxscreensaver --daemon"
echo "  Hyprland:  exec-once = wxscreensaver --daemon"
echo "  labwc:     wxscreensaver --daemon &   (autostart fájl)"

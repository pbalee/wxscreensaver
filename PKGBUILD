# Maintainer: pbalee
#
# Helyi építés a repó klónjából:
#   git clone https://github.com/pbalee/wxscreensaver
#   cd wxscreensaver
#   makepkg -si
pkgname=wxscreensaver
pkgver=0.1.1
pkgrel=1
pkgdesc="Wayland-compatible replacement for the XScreenSaver daemon (runs the original hacks, GTK3 settings GUI)"
arch=('any')
url="https://github.com/pbalee/wxscreensaver"
license=('MIT')
depends=('python' 'python-gobject' 'gtk3' 'xscreensaver' 'xorg-xwayland')
optdepends=('swayidle: idle detection outside GNOME (sway, Hyprland, labwc, KDE, ...)'
            'mesa-utils: glxinfo, used to find the GL visual if xscreensaver-gl-visual is missing'
            'vulkan-driver: GPU-accelerated Zink fallback for GL hacks'
            'vulkan-tools: vulkaninfo, shown in the --diagnose report')
install=wxscreensaver.install
source=('wxscreensaver' 'LICENSE' 'README.md')
sha256sums=('SKIP' 'SKIP' 'SKIP')   # helyi fájlok, nincs letöltés

package() {
    install -Dm755 "$srcdir/wxscreensaver" "$pkgdir/usr/bin/wxscreensaver"
    install -Dm644 "$srcdir/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 "$srcdir/README.md" "$pkgdir/usr/share/doc/$pkgname/README.md"

    # beállító GUI a menüben
    install -d "$pkgdir/usr/share/applications"
    cat > "$pkgdir/usr/share/applications/wxscreensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=wxscreensaver
Comment=Screensaver settings for Wayland
Exec=wxscreensaver --settings
Icon=preferences-desktop-screensaver
Categories=Settings;DesktopSettings;
EOF

    # a daemon automatikus indítása bejelentkezéskor (minden felhasználónak)
    install -d "$pkgdir/etc/xdg/autostart"
    cat > "$pkgdir/etc/xdg/autostart/wxscreensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=wxscreensaver
Comment=Wayland screensaver daemon
Exec=wxscreensaver --daemon
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF
}

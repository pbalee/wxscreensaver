#!/usr/bin/env bash
# wxscreensaver eltávolító
#   ./uninstall.sh                   program + indítók + beállítások + gyorsítótár törlése
#   ./uninstall.sh --keep-config     a beállításokat (~/.config/wxscreensaver) megtartja
#   ./uninstall.sh --remove-xscreensaver   az eredeti xscreensaver csomagot is eltávolítja
set -uo pipefail

KEEP_CONFIG=0
REMOVE_XSS=0
for a in "$@"; do
    case "$a" in
        --keep-config) KEEP_CONFIG=1 ;;
        --remove-xscreensaver) REMOVE_XSS=1 ;;
        *) echo "Ismeretlen kapcsoló: $a"; exit 1 ;;
    esac
done

echo "==> Futó daemon leállítása"
wxscreensaver --quit 2>/dev/null || true
pkill -f 'wxscreensaver --daemon' 2>/dev/null || true
pkill -x swayidle 2>/dev/null || true   # a daemon swayidle-je; ha másra is használod, indítsd újra

echo "==> Program és indítók törlése"
sudo rm -f /usr/local/bin/wxscreensaver
rm -f "$HOME/.local/share/applications/wxscreensaver.desktop"
rm -f "$HOME/.config/autostart/wxscreensaver.desktop"

echo "==> Az eredeti xscreensaver autostart-tiltásának feloldása"
rm -f "$HOME/.config/autostart/xscreensaver.desktop"
systemctl --user unmask xscreensaver.service 2>/dev/null || true

echo "==> Gyorsítótár törlése"
rm -rf "$HOME/.cache/wxscreensaver"

if [ "$KEEP_CONFIG" -eq 0 ]; then
    echo "==> Beállítások törlése"
    rm -rf "$HOME/.config/wxscreensaver"
else
    echo "==> Beállítások megtartva: ~/.config/wxscreensaver"
fi

if [ "$REMOVE_XSS" -eq 1 ]; then
    echo "==> Az eredeti xscreensaver eltávolítása"
    sudo pacman -Rns --noconfirm xscreensaver
fi

echo
echo "Kész. Ellenőrzés: 'which wxscreensaver' nem írhat ki semmit."

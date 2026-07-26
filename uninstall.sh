#!/bin/sh
# Deinstallation von heatpump-novolto auf Venus OS (als root auf dem GX)
# Entfernt Service, rc.local-Eintrag und /data/heatpump-novolto komplett.
# Betrifft NICHT die stabile dbus-novolto-Installation.
set -e
DEST=/data/heatpump-novolto
SVC=/service/heatpump-novolto
RCLOCAL=/data/rc.local

echo ">> Stoppe Service"
[ -e "$SVC" ] && svc -d "$SVC" 2>/dev/null || true

echo ">> Entferne Service-Symlink"
rm -f "$SVC"

echo ">> Entferne rc.local-Eintrag"
if [ -f "$RCLOCAL" ]; then
  grep -v "heatpump-novolto" "$RCLOCAL" > "$RCLOCAL.tmp" || true
  mv "$RCLOCAL.tmp" "$RCLOCAL"
  chmod 755 "$RCLOCAL"
fi

echo ">> Entferne $DEST"
rm -rf "$DEST"

echo ">> Fertig. heatpump-novolto ist deinstalliert."
echo "   Die stabile dbus-novolto-Installation ist unveraendert."

#!/bin/sh
# Installation von heatpump-novolto auf Venus OS (als root auf dem GX)
# Braucht Venus OS BETA mit com.victronenergy.heatpump-Unterstuetzung.
# Eigener Pfad/Servicename, laeuft parallel zur stabilen dbus-novolto-
# Installation, ohne diese zu beeinflussen.
set -e
SRC=$(dirname "$(readlink -f "$0")")
DEST=/data/heatpump-novolto

echo ">> Kopiere nach $DEST"
mkdir -p "$DEST"
cp -r "$SRC/heatpump-novolto.py" "$SRC/uninstall.sh" "$SRC/service" "$DEST/"
[ -f "$DEST/config.ini" ] || cp "$SRC/config.ini" "$DEST/"
chmod 755 "$DEST/heatpump-novolto.py" "$DEST/uninstall.sh" \
    "$DEST/service/run" "$DEST/service/log/run"
# config.ini enthaelt ggf. ein Klartext-MQTT-Passwort -- nicht world-readable
chmod 600 "$DEST/config.ini"

echo ">> Pruefe paho-mqtt"
python3 -c "import paho.mqtt.client" 2>/dev/null || {
  echo "   installiere python3-paho-mqtt..."
  opkg update && opkg install python3-paho-mqtt
}

echo ">> Registriere Service"
ln -sfn "$DEST/service" /service/heatpump-novolto

echo ">> rc.local Eintrag (update-fest)"
RCLOCAL=/data/rc.local
LINE='ln -sfn /data/heatpump-novolto/service /service/heatpump-novolto'
[ -f "$RCLOCAL" ] || { echo '#!/bin/sh' > "$RCLOCAL"; chmod 755 "$RCLOCAL"; }
grep -qF "$LINE" "$RCLOCAL" || echo "$LINE" >> "$RCLOCAL"

echo ">> Fertig. Vorher config.ini anpassen: $DEST/config.ini"
echo "   (config.ini.example im Projektordner als Vorlage nehmen, falls"
echo "   noch keine config.ini existiert)"
echo "   Start/Neustart:  svc -t /service/heatpump-novolto"
echo "   Log:             tail -f /var/log/heatpump-novolto/current | tai64nlocal"
echo "   Deinstallieren:  sh $DEST/uninstall.sh"

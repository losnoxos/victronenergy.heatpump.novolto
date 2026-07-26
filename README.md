# heatpump-novolto (experimentell)

**Fork von [dbus-novolto](https://github.com/losnoxos/dbus-novolto).** Testet den
nativen `com.victronenergy.heatpump`-Gerätetyp, den Venus OS seit ca.
V3.80-Beta kennt — das Pendant zu `com.victronenergy.evcharger` für
Wallboxen (z.B. Warp3).

**Braucht Venus OS BETA** mit Heatpump-Unterstützung. Auf stabilem
Venus OS zeigt sich vermutlich kein Unterschied zur bisherigen
`acload`-Variante, da die GUI dort den neuen Typ (noch) nicht kennt.

## Warum ein eigenes Repo statt einer neuen Version von dbus-novolto?

Victron selbst bezeichnet den Heatpump-Gerätetyp im
[dbus-Wiki](https://github.com/victronenergy/venus/wiki/dbus) als
**"under development"** — insbesondere das `/State`-Enum ist noch nicht
final festgelegt. dbus-novolto (die stabile Version) bleibt unverändert
für alle nutzbar; dieser Fork ist zum Testen/Vergleichen und kann sich
jederzeit wieder ändern, sobald Victron die Schnittstelle finalisiert.

## Was ist anders als in dbus-novolto?

- Registriert sich als `com.victronenergy.heatpump.novolto` statt
  `com.victronenergy.acload.novolto`
- Zusätzlich zu allen bisherigen Switch-Pane-Feldern (Ein/Aus-Status,
  Leistung, Max. Temperatur, Hysterese — unverändert, nichts geht
  verloren) werden die nativen Heatpump-Pfade befüllt:
  - `/Temperature` (aus `avtw`)
  - `/TargetTemperature` (schreibbar, synchron mit dem Max.-Temperatur-Feld,
    publiziert `sptw` genau wie bisher)
  - `/Ac/Power`, `/Ac/Energy/Forward`, `/Position` (wie bisher)
  - `/State` — **provisorisch geraten** (0=aus/1=an, aus derselben
    `avp`-Schwelle wie die bisherige Ein/Aus-Anzeige), da Victron das
    Enum noch nicht definiert hat
- Eigener Installationspfad (`/data/heatpump-novolto`,
  `/service/heatpump-novolto`) — läuft parallel zur stabilen
  Installation, ohne diese zu stören. Beide gleichzeitig zu betreiben
  (auf unterschiedlichen `deviceinstance_*`-Werten in der jeweiligen
  `config.ini`) funktioniert zum direkten Vergleich.

## Installation

Am einfachsten per `deploy-to-cerbo.bat` (Windows): kopiert die Dateien,
installiert und startet den Treiber neu — alles in einem Passwort-Login.
Existiert lokal noch keine `config.ini`, holt sich das Skript beim
ersten Lauf automatisch die Werte von der bestehenden stabilen
`dbus-novolto`-Installation und passt `deviceinstance_*`/`name`
automatisch an (43/44/45, "Novolto Heatpump BETA") — kein manuelles
`nano`/`vi` mehr nötig. Ab dann liegt die `config.ini` lokal und wird
bei jedem weiteren Deploy wiederverwendet.

Manuell geht's auch:

1. Venus OS Beta mit Heatpump-Unterstützung auf dem Cerbo installieren.
2. Ordner auf den Cerbo kopieren, z.B. per scp nach `/data/tmp/`.
3. `config.ini` aus `config.ini.example` erstellen (gleiche Felder wie
   bei dbus-novolto, aber eigene `deviceinstance_*`-Werte).
4. `sh /data/tmp/heatpump-novolto/install.sh`

Neustart: `svc -t /service/heatpump-novolto`
Log: `tail -f /var/log/heatpump-novolto/current | tai64nlocal`

## Was zu testen ist

- Zeigt Venus OS Beta ein natives Heatpump-Karte/Icon im Device List
  oder GUI-v2, das mehr kann als die bisherige Switch-Pane-Lösung?
- Lässt sich `/TargetTemperature` über ein natives GUI-Element setzen
  (nicht nur über das bisherige Switch-Pane-Feld)?
- Zeigt VRM das Gerät korrekt als Heatpump-Verbrauch an (im Forum gab
  es dazu noch offene Bugs, Stand der Recherche für dieses Repo)?
- Wie reagiert die GUI auf das geratene `/State` (0/1)?

Rückmeldungen dazu bitte im Projekt vermerken — die Ergebnisse fließen
zurück in die Entscheidung, ob/wann eine echte Migration von
dbus-novolto sinnvoll ist.

## Protokoll-Referenz

Identisch zu dbus-novolto, siehe [NOVOLTO-MQTT.md](NOVOLTO-MQTT.md).

## Lizenz

MIT, siehe [LICENSE](LICENSE).

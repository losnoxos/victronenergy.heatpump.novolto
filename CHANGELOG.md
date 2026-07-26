# Changelog

All notable changes to this project are documented here. Format based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0-beta] - 2026-07-26

First fully tested state. The `-beta` suffix stays as long as Venus OS
itself lists the `heatpump` device type as "under development" — 1.0.0
here means "first tested, documented state", not "production-ready".

### Added
- Registers the Novolto as `com.victronenergy.heatpump.novolto` (the
  native "Heatpump" device type Venus OS has known since roughly
  V3.80-beta, the counterpart to `com.victronenergy.evcharger` for
  wallboxes) alongside all the existing SwitchableOutput fields from
  [dbus-novolto](https://github.com/losnoxos/dbus-novolto) (Ein/Aus
  status, power, max. temperature, hysteresis) — nothing is lost.
- Native heatpump paths in addition: `/Temperature`, `/TargetTemperature`
  (writable, kept in sync with the max.-temperature field),
  `/Ac/Power`, `/Ac/Energy/Forward`, `/Position`, `/State` (provisional
  0/1 guess — Victron hasn't defined this enum yet).
- Own MQTT client ID, log path, Switch Pane group, and default device
  name — no more overlap with the stable installation when running
  both side by side.
- `config.ini` auto-provisioning in the deploy script (pulls settings
  from the existing stable installation, adjusts device instances).
- `uninstall.sh`.
- Log visibility for connection loss to the Novolto (one line on loss,
  one on recovery, no repeats).

### Test result
On the Venus OS beta version tested, the heatpump device type does not
(yet) get its own GUI treatment — it just shows up generically under
"AC Loads", the same as the stable `acload` version. See
[README.md](README.md) for details.

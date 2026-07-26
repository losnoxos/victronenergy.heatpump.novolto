# heatpump-novolto

*[Deutsche Version](README.de.md)*

**Tested, stable fork of [dbus-novolto](https://github.com/losnoxos/dbus-novolto).**
Registers the Novolto as the native `com.victronenergy.heatpump` device
type that Venus OS has known since roughly V3.80-beta — the
counterpart to `com.victronenergy.evcharger` for wallboxes (e.g. Warp3).

**Requires Venus OS BETA** with heatpump support — that's the one hard
prerequisite. On stable Venus OS there's presumably no visible
difference from the existing `acload` variant, since the GUI there
doesn't (yet) know the new type.

## Why a separate repo instead of a new version of dbus-novolto?

Not because the code here is less reliable — it's tested and runs the
same as dbus-novolto. The reason is upstream: Victron itself still
lists the heatpump device type in its
[dbus wiki](https://github.com/victronenergy/venus/wiki/dbus) as
**"under development"**, and in particular the `/State` enum isn't
finalized yet. dbus-novolto (the stable version) stays unchanged and
usable for everyone; this fork tracks Victron's upcoming interface and
will likely need small adjustments once they finalize it.

## What's different from dbus-novolto?

- Registers as `com.victronenergy.heatpump.novolto` instead of
  `com.victronenergy.acload.novolto`
- In addition to all the existing Switch Pane fields (Ein/Aus status,
  power, max. temperature, hysteresis — unchanged, nothing is lost),
  the native heatpump paths are populated:
  - `/Temperature` (from `avtw`)
  - `/TargetTemperature` (writable, kept in sync with the
    max.-temperature field, publishes `sptw` exactly as before)
  - `/Ac/Power`, `/Ac/Energy/Forward`, `/Position` (as before)
  - `/State` — **provisional guess** (0=off/1=on, from the same `avp`
    threshold as the existing Ein/Aus status), since Victron hasn't
    defined the enum yet
- Own installation path (`/data/heatpump-novolto`,
  `/service/heatpump-novolto`) — runs alongside the stable
  installation without disturbing it. Running both at the same time
  (with different `deviceinstance_*` values in each `config.ini`)
  works fine for direct comparison.

## Installation

Easiest via `deploy-to-cerbo.bat` (Windows, not part of the repo — see
[note on local files](#note-on-local-files) below): copies the files,
installs, and restarts the driver — all in one password login. If
there's no local `config.ini` yet, the script automatically fetches
the values from the existing stable `dbus-novolto` installation on its
first run and adjusts `deviceinstance_*`/`name` accordingly (43/44/45,
"Novolto Heatpump BETA") — no manual `nano`/`vi` needed. From then on,
`config.ini` lives locally and gets reused on every further deploy.

Manual installation also works:

1. Install Venus OS beta with heatpump support on the Cerbo.
2. Copy the folder to the Cerbo, e.g. via scp to `/data/tmp/`.
3. Create `config.ini` from `config.ini.example` (same fields as
   dbus-novolto, but with your own `deviceinstance_*` values).
4. `sh /data/tmp/heatpump-novolto/install.sh`

Restart: `svc -t /service/heatpump-novolto`
Log: `tail -f /var/log/heatpump-novolto/current | tai64nlocal`
Uninstall: `sh /data/heatpump-novolto/uninstall.sh` (removes the
service, the rc.local entry, and `/data/heatpump-novolto` entirely;
doesn't touch the stable `dbus-novolto` installation)

## Test results so far

- **No dedicated GUI icon/tile**, unlike the wallbox type
  (`evcharger`, e.g. Warp3). On the beta version tested, the heatpump
  entry just shows up generically in the device list under "AC
  Loads", correctly named but without any special treatment. Matches
  the "under development" status in the Victron wiki.
- **Switch Pane group and device name must differ from the stable
  repo**, otherwise Venus OS visually mixes the Switch Pane controls
  of both services into one group (it groups globally by the
  `Settings/Group` string, not per service). Hence `"Novolto
  Heatpump"` instead of `"Novolto"`, and `"Novolto Heatpump BETA"`
  instead of `"Novolto Heizstab"` as the default name.
- Otherwise the native part works technically as expected:
  `/Temperature`, `/TargetTemperature`, `/Ac/Power` etc. sync
  correctly once `config.ini` is right.

## Still open

- Can `/TargetTemperature` be set via a native GUI element (not just
  the existing Switch Pane field)? Currently there's no GUI that
  would display it any differently from a plain number.
- Does VRM show the device correctly as heatpump consumption (the
  forum had open bugs about this, as of the research done for this
  repo)?
- How will a future GUI version react to the guessed `/State` (0/1)
  once Victron finalizes the enum?

Please note any findings in the project — the results feed back into
the decision on whether/when a real migration of dbus-novolto makes
sense.

## Note on local files

`config.ini` and `deploy-to-cerbo.bat` are deliberately not part of
this repo (`.gitignore`) — they contain real credentials and a private
LAN IP, respectively. `config.ini.example` serves as a template.

## Protocol reference

See [NOVOLTO-MQTT.md](NOVOLTO-MQTT.md).

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT, see [LICENSE](LICENSE).

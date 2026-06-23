# Rime config layout

This repository is the source of truth for Rime configuration. The runtime Rime user directory should be generated from these layers instead of edited directly.

## Layout

- `common/`: shared schemas, dictionaries, Lua modules, OpenCC data, and symbols.
- `platforms/trime/`: Android Trime-specific overlays such as `trime.yaml` and `default.custom.yaml`.
- `platforms/weasel/`: Windows Weasel overlays such as `weasel.custom.yaml`.
- `platforms/ibus-rime/`: Linux ibus-rime overlays such as `ibus_rime.custom.yaml`.
- `private/`: personal phrases and local-only data that should override shared files when deployed.
- `scripts/`: deployment helpers.

## Deploy

```sh
scripts/deploy-trime.sh /path/to/rime-user-dir
scripts/deploy-ibus-rime.sh /path/to/rime-user-dir
```

For Weasel on Windows, use PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\deploy-weasel.ps1 "$env:APPDATA\Rime"
```

All deploy scripts apply layers in this order:

1. `common/`
2. `private/`
3. `platforms/<platform>/`

The script refuses to deploy into the source repository itself. Keep this repository separate from the live Rime directory when possible.

## Sync policy

Use Git for configuration source files. Use Rime's official sync plus Syncthing or another file sync tool only for exported user dictionary snapshots.

Recommended `installation.yaml` fields per device:

```yaml
installation_id: "android-pad"
sync_dir: "/path/to/RimeSync"
```

Do not sync raw runtime databases directly:

- `*.userdb/`
- `lua/predict*`
- compiled `*.bin` / `*.tabledb` artifacts
- `user.yaml`
- `installation.yaml`

For Wanxiang `user_predict`, prefer one prediction database per device. It is a live LevelDB-style runtime database and is not safe to merge with ordinary file sync.

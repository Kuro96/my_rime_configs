# Rime config layout

This repository is the source of truth for Rime configuration. The runtime Rime user directory should be generated from these layers instead of edited directly.

## Layout

- `common/`: shared schemas, dictionaries, Lua modules, OpenCC data, and symbols.
- `templates/`: shared templates that deploy scripts turn into root-level Rime files.
- `platforms/trime/`: Android Trime-specific overlays such as `trime.yaml` and `default.custom.yaml.patch`.
- `platforms/weasel/`: Windows Weasel overlays such as `weasel.custom.yaml` and `default.custom.yaml.patch`.
- `platforms/ibus-rime/`: Linux ibus-rime overlays such as `ibus_rime.custom.yaml` and `default.custom.yaml.patch`.
- `private/`: personal phrases and local-only data that should override shared files when deployed.
- `scripts/`: deployment helpers.

## Deploy

```sh
scripts/deploy-trime.sh [path/to/rime-user-dir]
scripts/deploy-ibus-rime.sh [path/to/rime-user-dir]
```

This repository may also be the live Rime user directory. In that case, run a
platform deploy script from the repository root; shell wrappers deploy into the
current directory by default, and generated root-level Rime files are ignored by
Git.

For Weasel on Windows, use PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\deploy-weasel.ps1 [path\to\rime-user-dir]
```

All deploy scripts apply layers in this order:

1. `common/`
2. `private/`
3. `platforms/<platform>/`
4. `templates/default.custom.yaml` patched by `platforms/<platform>/default.custom.yaml.patch` into generated root `default.custom.yaml`

Do not edit generated root-level files such as `default.custom.yaml` directly.
Change `templates/default.custom.yaml` for shared defaults, or the platform patch
for platform-specific differences.

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

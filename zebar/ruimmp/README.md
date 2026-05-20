# 📊 ruimmp - Zebar Pack

Custom [Zebar](https://github.com/glzr-io/zebar) v3 pack. A full-width status bar built with React + Vite.

Installed to `~/.glzr/zebar/ruimmp/`.

## Pack contents

```
ruimmp/
  zpack.json      # pack manifest
  V1/             # the widget - see V1/README.md for full details
```

## Quick setup

The installer handles everything:

1. Copies the pack to `~/.glzr/zebar/ruimmp/`
2. Runs `npm install && npm run build` inside `V1/`
3. Sets ruimmp as the default startup config in `~/.glzr/zebar/settings.json`

## Manual setup

```powershell
Copy-Item zebar\ruimmp "$env:USERPROFILE\.glzr\zebar\ruimmp" -Recurse -Force
cd "$env:USERPROFILE\.glzr\zebar\ruimmp\V1"
npm install
npm run build
```

Then set it as default in `~/.glzr/zebar/settings.json`:

```json
{
  "$schema": "https://github.com/glzr-io/zebar/raw/v3.1.1/resources/settings-schema.json",
  "startupConfigs": [{ "pack": "ruimmp", "widget": "V1", "preset": "default" }]
}
```

Restart Zebar (or `alt+shift+z` in GlazeWM) to load the bar.

## Customisation

See [V1/README.md](V1/README.md) for config options, theming, and build instructions.

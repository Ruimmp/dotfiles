# 📊 V1 Widget

The bar widget for the ruimmp Zebar pack. React + Vite app, 40px full-width top bar.

## Widget layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Left              │         Center          │              Right        │
│  logo · host · OS  │   workspace buttons     │  media · time · weather  │
│                    │                         │  cpu · ram · bat · kb · ⏻ │
└─────────────────────────────────────────────────────────────────────────┘
```

## 📂 File structure

```
V1/
  config/
    config.js     ← feature toggles and widget behaviour (edit this)
    theme.js      ← colours, fonts, layout (edit this)
  src/
    main.jsx                      widget entry point
    styles.css                    CSS with custom property theming
    components/
      core/PowerMenu.jsx          shutdown/restart/sleep/lock/signout
      core/Shortcut.jsx           app launcher buttons
      media/MediaWidget.jsx       now-playing + controls
      search/WebSearch.jsx        inline search bar
      settings/Settings.jsx       settings panel
    hooks/useTheme.js             maps theme.js → CSS variables on :root
    utils/utils.js                throttle helper
  index.html
  package.json
  vite.config.js
```

## ⚙️ Configuration - config.js

All user-facing behaviour lives in `config/config.js`. No source code changes needed for common customisations.

### Media player
```js
media: {
  enabled: true,
  display: { showControlsOnHover: true }  // hover to show prev/play/next
}
```

### Date and time
```js
dateTime: {
  defaultFormat: "h:mm a",           // shown in bar
  hoverFormat:   "ddd, MMM D • h:mm a"  // shown on hover
}
```
Moment.js format tokens: [momentjs.com/docs/#/displaying/format](https://momentjs.com/docs/#/displaying/format/)

### Keyboard layout
```js
keyboard: {
  enabled: true,
  layoutOverride: "Swiss Fr"  // null → show system layout code (e.g. "en-US")
}
```

### Power menu
```js
powerMenu: {
  enabled:          true,
  options:          ["shutdown", "restart", "sleep"],  // also: "lock", "signout"
  direction:        "left",    // which side the menu opens
  alwaysOpen:       false,     // true → always expanded
  autoCloseTimeout: 5000       // ms, false → no auto-close
}
```

### System stats (CPU / RAM)
```js
systemStats: {
  enabled: true,
  widgets: {
    cpu:    { enabled: true, warningThreshold: 80 },
    memory: { enabled: true, warningThreshold: 80 }
  }
}
```

### Battery
```js
battery: {
  enabled:          true,
  warningThreshold: 20,
  showChargingIcon: true
}
```

### Weather
```js
weather: {
  enabled: true,
  unit: "celsius"  // or "fahrenheit"
}
```

### App shortcuts (left side)
```js
shortcuts: {
  enabled: false,
  showLabels: false,
  showLabelsOnHover: true,
  items: [
    { name: "Terminal", icon: "nf-md-console", command: "wt.exe", workspace: "8" },
    { name: "Files",    icon: "nf-md-folder",  command: "explorer" }
  ]
}
```

## 🎨 Theming - theme.js

Colours, fonts, and geometry. `useTheme.js` maps these to CSS custom properties on `:root`.

```js
// Key values - full file has more
colors: {
  primary:    "rgba(100, 105, 110, 0.95)",  // widget container background
  background: "linear-gradient(...)",        // bar background
  text:       "rgba(255, 255, 255, 0.92)",
}
fonts:  { size: "13px", family: "monospace" }
layout: { borderRadius: "12px", barHeight: "36px", blurAmount: "16px" }
```

## 🔨 Build

After editing any file under `src/` or `config/`:

```powershell
cd ~/.glzr/zebar/ruimmp/V1
npm install   # only needed when package.json changes
npm run build
```

Then restart Zebar (`alt+shift+z` in GlazeWM or from the tray).

## Requirements

- [Node.js](https://nodejs.org/) (LTS)
- [Zebar](https://github.com/glzr-io/zebar) v3+
- [Hack Nerd Font](https://www.nerdfonts.com/) for icons

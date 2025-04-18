# ✨ Ruimmp Dash - Modern Status Bar for Zebar

A highly configurable, feature-rich status bar built on the Zebar framework. This sleek, modern interface enhances your desktop with system monitoring, media controls, shortcuts, and more - all while being fully customizable to match your workflow.

![Ruimmp-Dash Preview](docs/images/main-preview.png)

## ✨ Features

- **Modular Design** - Enable only what you need, disable what you don't
- **System Monitoring** - Track CPU, memory, battery with configurable thresholds
- **Media Controls** - See what's playing and control your media without switching apps
- **Smart Shortcuts** - Quick launch applications with optional workspace focusing
- **Power Controls** - Elegant power menu with customizable options
- **Weather Widget** - Current conditions with automatic icon selection
- **Search Integration** - Quick web searches from your status bar
- **Extensive Theming** - Detailed control over colors, fonts, animations, and layout
- **Responsive Design** - Adapts to different screen sizes and configurations

## 📋 Requirements

- [Zebar](https://github.com/glzr-io/zebar) v2.7.0+

  ```powershell
  # Install using winget
  winget install glzr-io.zebar
  ```

- [Node.js](https://nodejs.org/) 16+ (for building)

  ```powershell
  # Install using winget
  winget install OpenJS.NodeJS.LTS
  ```

- [Nerd Fonts](https://www.nerdfonts.com/) (for icons)

  ```powershell
  # Install JetBrains Mono Nerd Font
  winget install DEVCOM.JetBrainsMonoNerdFont
  ```

After installing, you may need to restart your terminal or system for the fonts to be recognized.

## 🚀 Quick Start

### Installation

1. Clone this repository to your dotfiles structure:

```bash
# Clone the dotfiles repository (if you haven't already)
git clone https://github.com/Ruimmp/dotfiles.git
cd dotfiles

# Switch to the Windows branch
git checkout windows

# The ruimmp-dash will be located in:
# dotfiles/
# ├── glazewm/
# │   └── config.yaml
# └── zebar/
#     └── ruimmp-dash/
#         └── project files

# Install dependencies
cd zebar/ruimmp-dash
npm install

# Build the widget
npm run build
```

2. Add the widget to Zebar:

```bash
# Edit the Zebar settings file
nano ~/.glzr/zebar/settings.json

# Add the following to the startupConfigs array:
# {
#   "path": "ruimmp-dash/main.zebar.json",
#   "preset": "default"
# }

# The complete file should look like:
# {
#   "$schema": "https://github.com/glzr-io/zebar/raw/v2.4.0/resources/settings-schema.json",
#   "startupConfigs": [
#     {
#       "path": "ruimmp-dash/main.zebar.json",
#       "preset": "default"
#     }
#   ]
# }

# Save the file and restart Zebar
```

### First Configuration

The default configuration works out of the box, but you'll likely want to customize it:

1. Edit `config/config.js` to enable/disable features
2. Edit `config/theme.js` to adjust colors and visual style
3. Rebuild using `npm run build`

## ⚙️ Configuration Guide

The following sections outline the main configuration options available in `config.js`. Each section can be enabled/disabled and customized to your preferences.

### 🎵 Media Player (`config.media`)

```js
media: {
  enabled: true,                    // Toggle the entire widget on/off
  display: {
    showControlsOnHover: true,      // Show playback controls on hover
  }
}
```

### 🔍 Web Search (`config.search`)

```js
search: {
  enabled: false,                   // Toggle search widget on/off
  explorerPath: "chrome",           // Browser to use (chrome, firefox, msedge, etc.)
  placeholder: "Search with Google..." // Placeholder text in search field
}
```

### 📌 Application Shortcuts (`config.shortcuts`)

```js
shortcuts: {
  enabled: false,                   // Toggle shortcuts section on/off
  showLabels: false,                // Always show text labels (true) or icons only (false)
  showLabelsOnHover: true,          // Show labels when hovering over icons (only if showLabels is false)
  items: [
    {
      name: "Terminal",             // Display name
      icon: "nf-md-console",        // Nerd Fonts icon class
      command: "wt.exe",            // Command to execute
      workspace: "8"                // Optional: focus this workspace first
    },
    // Add more shortcuts as needed
  ]
}
```

### 🕒 Date and Time (`config.dateTime`)

```js
dateTime: {
  defaultFormat: "h:mm a",          // Normal display format (e.g., "3:42 pm")
  hoverFormat: "ddd, MMM D • h:mm a" // Format when hovering (e.g., "Mon, Jan 15 • 3:42 pm")
}
```

### ⌨️ Keyboard Layout (`config.keyboard`)

```js
keyboard: {
  enabled: true,                    // Toggle keyboard indicator on/off
  layoutOverride: "Swiss Fr"        // Custom text (null to use system code)
}
```

### ⚡ Power Menu (`config.powerMenu`)

```js
powerMenu: {
  enabled: true,                    // Toggle power menu on/off
  autoCloseTimeout: 5000,           // Close after 5 seconds (false to disable)
  direction: "left",                // Menu direction: "left" or "right"
  alwaysOpen: false,                // Always show all options (no toggle button)
  options: ["shutdown", "restart", "sleep", "lock", "signout"] // Available buttons
}
```

### 📊 System Stats (`config.systemStats`)

```js
systemStats: {
  enabled: true,                    // Master toggle for all system stats
  widgets: {
    cpu: {
      enabled: true,                // Toggle CPU monitor
      warningThreshold: 80          // Highlight when usage exceeds 80%
    },
    memory: {
      enabled: true,                // Toggle memory monitor
      warningThreshold: 80          // Highlight when usage exceeds 80%
    }
  }
}
```

### 🔋 Battery Display (`config.battery`)

```js
battery: {
  enabled: true,                    // Toggle battery indicator
  warningThreshold: 20,             // Low battery warning threshold
  showChargingIcon: true            // Show lightning bolt when charging
}
```

### 🌤️ Weather Widget (`config.weather`)

```js
weather: {
  enabled: true,                    // Toggle weather widget
  unit: "celsius"                   // "celsius" or "fahrenheit"
}
```

### 🪟 Window Manager (`config.windowManager`)

```js
windowManager: {
  enableTilingDirection: false; // Show tiling direction toggle button
}
```

### 🔬 Debug Options (`config.debug`)

```js
debug: {
  simulateBattery: {
    enabled: false,                 // Simulate battery for desktop PCs
    percentage: 15,                 // Simulated battery level
    isCharging: true                // Simulated charging state
  }
}
```

### Visual Styling (`theme.js`)

The `theme.js` file controls all visual aspects of the status bar including colors, fonts, layout, and animations.

#### Colors

```js
colors: {
  // Primary theme colors
  primary: {
    main: "rgba(94, 129, 244, 0.95)",  // Icons, borders, active states
    light: "rgba(94, 129, 244, 0.12)",  // Backgrounds, hover states
    dark: "rgba(66, 99, 235, 0.95)"     // Pressed states, highlights
  },

  // Background colors
  background: {
    main: "linear-gradient(180deg, rgba(22, 28, 36, 0.95), rgba(28, 34, 46, 0.90))", // Main bar
    light: "rgba(255, 255, 255, 0.06)", // Secondary backgrounds
    hover: "rgba(255, 255, 255, 0.12)"  // Hover state backgrounds
  },

  // Text colors
  text: {
    primary: "rgba(255, 255, 255, 0.92)",   // Main text
    secondary: "rgba(255, 255, 255, 0.65)"  // Secondary text, placeholders
  },

  // Warning and important indicators
  accent: "rgba(255, 85, 131, 0.95)",

  // Power menu buttons colors
  power: {
    shutdown: "rgba(255, 85, 131, 0.95)",  // Red
    restart: "rgb(79, 195, 247)",          // Blue
    sleep: "rgb(105, 220, 150)",           // Green
    lock: "rgb(255, 213, 79)",             // Yellow
    signout: "rgb(255, 138, 128)"          // Coral
  },

  // Widget styling
  widgets: {
    background: "rgba(94, 129, 244, 0.07)",   // Widget background
    border: "rgba(94, 129, 244, 0.15)",       // Widget border
    hoverBackground: "rgba(94, 129, 244, 0.14)" // Hover state
  },

  // Search widget colors
  search: {
    background: "rgba(22, 28, 36, 0.95)",       // Search input background
    border: "rgba(94, 129, 244, 0.2)",          // Search border
    shadow: "0 2px 10px rgba(0, 0, 0, 0.25)",   // Shadow effect
    buttonBackground: "rgba(94, 129, 244, 0.12)", // Button background
    buttonHover: "rgba(94, 129, 244, 0.25)"      // Button hover
  }
}
```

#### Typography

```js
fonts: {
  // Font family (requires Nerd Fonts to be installed)
  family: '"JetBrainsMono Nerd Font", "FiraCode Nerd Font", monospace',
  size: "13px",  // Base font size

  // Icon scaling for different icon families
  icons: {
    scale: {
      md: 1.05,       // Material Design icons
      fa: 1,          // Font Awesome icons
      oct: 1.05,      // Octicons
      weather: 1.15,  // Weather icons
    },
    charging: "7px"   // Battery charging indicator size
  }
}
```

#### Layout

```js
layout: {
  // Corner radius settings
  radius: {
    container: { style: "rounded", value: "12px" },  // Main containers
    workspace: { style: "rounded", value: "5px" },   // Workspace buttons
    shortcut: { style: "rounded", value: "5px" },    // App shortcuts
    control: { style: "rounded", value: "6px" }      // Control buttons
  },

  // Button styling
  buttons: {
    workspace: {
      padding: "4px 9px",  // Internal padding
      margin: "0 3px",     // Space between buttons
      border: "0px",       // Border width
      scale: "1.05"        // Hover scale effect
    },
    shortcut: {
      padding: "3px 8px",
      margin: "0 1px",
      border: "1px",
      scale: "1.03"
    },
    control: {
      padding: "4px 9px",
      margin: "0 3px",
      border: "1px",
      scale: "1.05"
    }
  },

  // Power menu appearance
  powerMenu: {
    hoverBrightness: 1.15,     // Brightness increase on hover
    hoverScale: 1.1,           // Size increase on hover
    buttonGap: "3px",          // Space between buttons
    buttonPadding: "4px 6px",  // Button padding
    buttonMargin: "0 1px"      // Button margin
  },

  // Widget styling
  widgets: {
    useContainers: true,       // Use background containers for widgets
    borderRadius: "6px",       // Container corner radius
    padding: "3px 8px",        // Padding inside containers
    gap: "3px",                // Space between elements
    hoverEffects: true         // Enable hover animations
  },

  // Search widget appearance
  search: {
    buttonPadding: "4px 8px",  // Search button padding
    buttonHeight: "26px",      // Search button height
    borderRadius: "6px",       // Corner radius
    animationSpeed: "0.3s",    // Expand/collapse animation speed
    expandedWidth: "220px"     // Width when expanded
  },

  // Main bar styling
  bar: {
    height: "36px",            // Bar height
    borderWidth: "2px",        // Border thickness
    borderStyle: "solid",      // Border style
    shadow: "0 2px 10px rgba(0, 0, 0, 0.15)",  // Shadow effect
    blurStrength: "10px"       // Backdrop blur amount
  },

  // Separators between widgets
  separator: {
    width: "1px",              // Separator thickness
    color: null,               // Color (null uses primary.light)
    opacity: 0.6,              // Normal opacity
    hoverOpacity: 0.9          // Opacity on hover
  }
}
```

#### Animations

```js
animations: {
  enable: true,  // Master switch for animations

  // Animation durations (milliseconds)
  speed: {
    fast: 150,     // Quick transitions
    normal: 250,   // Standard transitions
    slow: 350      // Slow transitions
  },

  // Animation timing functions
  easing: {
    hover: "cubic-bezier(0.19, 1, 0.22, 1)",  // Smooth hover animations
    menu: "cubic-bezier(0.25, 1, 0.5, 1)"     // Menu open/close animations
  }
}
```

## 📸 Screenshots & Examples

Here are some examples of different configurations you can achieve:

### Default Theme

![Default Theme](https://i.imgur.com/W4GUzkl.png)

### Full-Featured Configuration

![Full-Featured](https://i.imgur.com/Lr60M8a.png)

### Minimal Configuration

![Minimal Setup](https://i.imgur.com/Vts7aQN.png)

### Power Menu Expanded

![Power Menu](https://i.imgur.com/Bw8GMRr.png)

### Media Player Controls

![Media Player](https://i.imgur.com/u19vNQS.png)

### Web Search Widget
![Web Search](https://i.imgur.com/vssgpzj.png)

## 🛠️ Development

### Adding Custom Widgets

1. Create a new component in `src/components/`
2. Import it in `main.jsx`
3. Add it to the appropriate section (left, center, or right)
4. Add configuration options to `config.js` if needed

Example of adding a custom component to the right section:

```jsx
// In main.jsx, inside the right section:
<div className="right">
  <div className="box">
    {/* Add your custom component here */}
    {config.yourFeature.enabled && (
      <YourCustomComponent
        commandRunner={output.glazewm.runCommand}
        // Other props
      />
    )}

    {/* ...existing components... */}
  </div>
</div>
```

## 💡 Tips & Tricks

### Using Nerd Fonts Icons

1. Browse available icons at the [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)
2. Use the icon classes in your configuration:
   - Material Design icons: `nf-md-`
   - Font Awesome icons: `nf-fa-`
   - Octicons: `nf-oct-`
   - Weather icons: `nf-weather-`

### Performance Optimization

- Disable widgets you don't use in `config.js`
- The `throttle` utility in `src/utils/utils.js` can be used to limit frequent updates

### Customizing Power Commands

Power commands are defined in the PowerMenu component. You can edit these commands to match your system or add custom actions:

```js
// In src/components/core/PowerMenu.jsx
const powerCommands = {
  shutdown: "shell-exec shutdown /s /t 0",
  restart: "shell-exec shutdown /r /t 0",
  sleep: "shell-exec rundll32.exe powrprof.dll,SetSuspendState 0,1,0",
  lock: "shell-exec rundll32.exe user32.dll,LockWorkStation",
  signout: "shell-exec shutdown /l",
  // Add your custom commands here
  hibernate: "shell-exec shutdown /h",
};
```

## 🔍 Troubleshooting

### Common Issues

**Icons not displaying correctly**

- Make sure you have a Nerd Font installed and set as your terminal/editor font
- Verify icon class names in your configuration match the Nerd Fonts naming

**Build errors**

- Check Node.js version (16+ recommended)
- Try removing node_modules and reinstalling: `rm -rf node_modules && npm install`

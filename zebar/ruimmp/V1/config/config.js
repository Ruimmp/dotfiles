export default {
  /**
   * Media Player Integration
   *
   * Controls functionality for the media playback widget that displays
   * current song information and playback controls.
   */
  media: {
    /** Enable/disable the media widget */
    enabled: true,

    display: {
      /**
       * When true: Previous/Play-Pause/Next buttons appear when hovering over the widget
       * When false: Controls are always hidden
       */
      showControlsOnHover: true,
    },
  },

  /**
   * Web Search Configuration
   *
   * Settings for the inline search functionality that opens
   * search queries in your configured browser.
   */
  search: {
    /** Enable/disable the search widget */
    enabled: false,

    /**
     * Path to the browser executable for launching searches
     *
     * Simplified paths work best to avoid escaping issues:
     * - "chrome"  - Uses default Chrome installation
     * - "firefox" - Uses default Firefox installation
     * - "msedge"  - Uses Microsoft Edge
     * - "brave"   - Uses Brave browser
     */
    explorerPath: "chrome",

    /** Text shown in the empty search input field */
    placeholder: "Search with Google...",
  },

  /**
   * Application Shortcuts Configuration
   *
   * Quick-launch buttons for commonly used applications,
   * optionally with workspace switching functionality.
   */
  shortcuts: {
    /** Enable/disable the shortcuts section */
    enabled: false,

    /**
     * true  - Full mode with icons and labels
     * false - Compact mode with icons only
     */
    showLabels: false,

    /**
     * true  - Show labels when hovering over icons
     * false - Always show icons only
     */
    showLabelsOnHover: true,

    /**
     * Each item can include:
     * - name:      Display name for the shortcut
     * - icon:      Icon class from Nerd Fonts (nf prefix)
     * - command:   Command/application to launch
     * - workspace: Optional workspace to focus before launching
     */
    items: [
      {
        name: "Terminal",
        icon: "nf-md-console",
        command: "wt.exe",
        workspace: "8",
      },
      {
        name: "Files",
        icon: "nf-md-folder",
        command: "explorer",
      },
    ],
  },

  /**
   * Date and Time Display Settings
   *
   * Moment.js formatting syntax: https://momentjs.com/docs/#/displaying/format/
   */
  dateTime: {
    /** Default time format — shown in the bar */
    defaultFormat: "h:mm a",

    /** Format shown when hovering over the time */
    hoverFormat: "ddd, MMM D • h:mm a",
  },

  /**
   * Keyboard Layout Indicator Settings
   */
  keyboard: {
    /** Enable/disable keyboard layout indicator */
    enabled: true,

    /**
     * Custom display text for keyboard layout.
     * null  → Shows system layout code (e.g. "en-US")
     * string → Shows that custom text instead
     */
    layoutOverride: "Swiss Fr",
  },

  /**
   * Power Menu Configuration
   */
  powerMenu: {
    /** Enable/disable the power menu widget */
    enabled: true,

    /**
     * Auto-close timeout in milliseconds.
     * false → Disables auto-close
     */
    autoCloseTimeout: 5000,

    /**
     * Direction the menu opens relative to the power button.
     * Options: "left" or "right"
     */
    direction: "left",

    /**
     * true  - Always display all power options (no toggle button)
     * false - Show toggle button that reveals options when clicked
     */
    alwaysOpen: false,

    /**
     * Available power options and their order.
     * Options: "shutdown", "restart", "sleep", "lock", "signout"
     */
    options: ["shutdown", "restart", "sleep"],
  },

  /**
   * System Statistics Widgets
   */
  systemStats: {
    /** Master switch for all system stat widgets */
    enabled: true,

    widgets: {
      cpu: {
        /** Enable/disable CPU usage indicator */
        enabled: true,

        /**
         * CPU usage percentage threshold for warning (0-100).
         * false → Disables warnings completely
         */
        warningThreshold: 80,
      },

      memory: {
        /** Enable/disable memory usage indicator */
        enabled: true,

        /**
         * Memory usage percentage threshold for warning (0-100).
         * false → Disables warnings completely
         */
        warningThreshold: 80,
      },
    },
  },

  /**
   * Battery Status Display
   */
  battery: {
    /** Enable/disable battery indicator */
    enabled: true,

    /** Battery percentage threshold for low battery warning (0-100) */
    warningThreshold: 20,

    /** Show charging lightning icon when connected to power */
    showChargingIcon: true,
  },

  /**
   * Weather Widget Settings
   */
  weather: {
    /** Enable/disable weather display */
    enabled: true,

    /**
     * Temperature unit preference.
     * Options: "celsius" (°C) or "fahrenheit" (°F)
     */
    unit: "celsius",
  },

  /**
   * Window Manager Controls
   */
  windowManager: {
    /**
     * Enable/disable tiling direction toggle button.
     * Adds a button to switch between horizontal and vertical tiling.
     */
    enableTilingDirection: false,
  },

  /**
   * Debug Settings
   */
  debug: {
    /** Battery simulation for devices without batteries */
    simulateBattery: {
      /**
       * Only activates when actual battery hardware is not detected.
       */
      enabled: false,

      /** Simulated battery level percentage (0-100) */
      percentage: 15,

      /** Simulated charging state */
      isCharging: true,
    },
  },
};

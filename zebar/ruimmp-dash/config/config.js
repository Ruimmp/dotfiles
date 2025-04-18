export default {
  /**
   * Media Player Integration
   *
   * Controls functionality for the media playback widget that displays
   * current song information and playback controls.
   */
  media: {
    /**
     * Enable/disable the media widget
     * Default: true
     */
    enabled: true,

    /**
     * Display options for media player controls
     */
    display: {
      /**
       * Controls whether playback buttons appear on hover
       *
       * When true: Previous/Play-Pause/Next buttons appear when hovering over the widget
       * When false: Controls are always hidden
       *
       * Default: true
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
    /**
     * Enable/disable the search widget
     * Default: false
     */
    enabled: false,

    /**
     * Path to the browser executable for launching searches
     *
     * Simplified paths work best to avoid escaping issues:
     * - "chrome" - Uses default Chrome installation
     * - "firefox" - Uses default Firefox installation
     * - "msedge" - Uses Microsoft Edge
     */
    explorerPath: "chrome",

    /**
     * Text shown in the empty search input field
     */
    placeholder: "Search with Google...",
  },

  /**
   * Application Shortcuts Configuration
   *
   * Quick-launch buttons for commonly used applications,
   * optionally with workspace switching functionality.
   */
  shortcuts: {
    /**
     * Enable/disable the shortcuts section
     * Default: false
     */
    enabled: false,

    /**
     * Control shortcut appearance
     *
     * true - Full mode with icons and labels
     * false - Compact mode with icons only
     *
     * Default: false
     */
    showLabels: false,

    /**
     * Show labels on hover (when showLabels is false)
     *
     * true - Show labels when hovering over icons
     * false - Always show icons only
     *
     * Default: true
     */
    showLabelsOnHover: true,

    /**
     * Application shortcuts configuration
     *
     * Each item can include:
     * - name: Display name for the shortcut
     * - icon: Icon class from Nerd Fonts (nf prefix)
     * - command: Command/application to launch
     * - workspace: Optional workspace to focus before launching
     *
     * Example:
     * {
     *   name: "VS Code",
     *   icon: "nf-dev-visualstudio",
     *   command: "code",
     *   workspace: "2"
     * }
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
   * Controls format and behavior of the date/time widget using
   * Moment.js formatting syntax.
   *
   * See: https://momentjs.com/docs/#/displaying/format/
   */
  dateTime: {
    /**
     * Default time format displayed in the bar
     *
     * Examples:
     * "h:mm a" → "3:42 pm"
     * "HH:mm:ss" → "15:42:23"
     * "ddd h:mm" → "Mon 3:42"
     */
    defaultFormat: "h:mm a",

    /**
     * Format displayed when hovering over the time
     *
     * Typically includes more detailed information than the default format.
     *
     * Examples:
     * "ddd, MMM D • h:mm a" → "Mon, Jan 15 • 3:42 pm"
     * "LLLL" → "Monday, January 15, 2023 3:42 PM"
     */
    hoverFormat: "ddd, MMM D • h:mm a",
  },

  /**
   * Keyboard Layout Indicator Settings
   *
   * Controls display of the current keyboard language/layout.
   */
  keyboard: {
    /**
     * Enable/disable keyboard layout indicator
     * Default: true
     */
    enabled: true,

    /**
     * Custom display text for keyboard layout
     *
     * When null: Shows system layout code (e.g., "en-US")
     * When string: Shows that custom text instead
     *
     * Example: "US" would display "US" instead of the system code
     */
    layoutOverride: "Swiss Fr",
  },

  /**
   * Power Menu Configuration
   *
   * Controls the power button and its options (shutdown, restart, etc.)
   */
  powerMenu: {
    /**
     * Enable/disable the power menu widget
     * Default: true
     */
    enabled: true,

    /**
     * Auto-close timeout in milliseconds
     *
     * 5000 = 5 seconds
     * false = Disables auto-close
     *
     * Default: 5000
     */
    autoCloseTimeout: 5000,

    /**
     * Direction the menu opens relative to the power button
     *
     * Options: "left" or "right"
     *
     * Default: "left"
     */
    direction: "left",

    /**
     * Visibility mode for power options
     *
     * true - Always display all power options (no toggle button)
     * false - Show toggle button that reveals options when clicked
     *
     * Default: false
     */
    alwaysOpen: false,

    /**
     * Available power options
     *
     * Controls which buttons are shown and in what order.
     * Options: "shutdown", "restart", "sleep", "lock", "signout"
     */
    options: ["shutdown", "restart", "sleep"],
  },

  /**
   * System Statistics Widgets
   *
   * Controls display of system resource monitors (CPU, memory).
   */
  systemStats: {
    /**
     * Master switch for all system stat widgets
     * Default: true
     */
    enabled: true,

    /**
     * Individual widget configuration
     */
    widgets: {
      /**
       * CPU usage widget configuration
       */
      cpu: {
        /**
         * Enable/disable CPU usage indicator
         * Default: true
         */
        enabled: true,

        /**
         * CPU usage percentage threshold for warning
         *
         * Set a number (0-100) to show warning at that threshold
         * Set false to disable warnings completely
         *
         * Default: 80
         */
        warningThreshold: 80,
      },

      /**
       * Memory usage widget configuration
       */
      memory: {
        /**
         * Enable/disable memory usage indicator
         * Default: true
         */
        enabled: true,

        /**
         * Memory usage percentage threshold for warning
         *
         * Set a number (0-100) to show warning at that threshold
         * Set false to disable warnings completely
         *
         * Default: 80
         */
        warningThreshold: 80,
      },
    },
  },

  /**
   * Battery Status Display
   *
   * Controls battery indicator appearance and behavior.
   */
  battery: {
    /**
     * Enable/disable battery indicator
     * Default: true - Shows when battery is detected
     */
    enabled: true,

    /**
     * Battery percentage threshold for low battery warning (0-100)
     * Default: 20
     */
    warningThreshold: 20,

    /**
     * Show charging lightning icon when connected to power
     * Default: true
     */
    showChargingIcon: true,
  },

  /**
   * Weather Widget Settings
   *
   * Controls temperature display and units.
   */
  weather: {
    /**
     * Enable/disable weather display
     * Default: true
     */
    enabled: true,

    /**
     * Temperature unit preference
     * Options: "celsius" (°C) or "fahrenheit" (°F)
     */
    unit: "celsius",
  },

  /**
   * Window Manager Controls
   *
   * Settings for GlazeWM-specific window management functions.
   */
  windowManager: {
    /**
     * Enable/disable tiling direction toggle button
     *
     * When enabled, adds a button to switch between horizontal
     * and vertical window tiling orientations.
     *
     * Default: false
     */
    enableTilingDirection: false,
  },

  /**
   * Debug Settings
   *
   * Development and testing options.
   */
  debug: {
    /**
     * Battery simulation for devices without batteries
     */
    simulateBattery: {
      /**
       * Enable/disable simulated battery
       *
       * Only activates when actual battery hardware is not detected.
       *
       * Default: false
       */
      enabled: false,

      /**
       * Simulated battery level percentage (0-100)
       * Default: 15
       */
      percentage: 15,

      /**
       * Simulated charging state
       * Default: true
       */
      isCharging: true,
    },
  },
};

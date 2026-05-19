export default {
  colors: {
    /**
     * Primary colors used throughout the UI
     * main:  Icons, borders, and active states
     * light: Backgrounds and hover states
     * dark:  Pressed states and highlights
     */
    primary: {
      main: "rgba(100, 105, 110, 0.95)",
      light: "rgba(100, 105, 110, 0.14)",
      dark: "rgba(75, 80, 85, 0.95)",
    },

    /**
     * Background colors
     * main:  Main taskbar background
     * light: Secondary backgrounds
     * hover: Hover states
     */
    background: {
      main: "linear-gradient(180deg, rgba(10, 11, 12, 0.94) 0%, rgba(12, 13, 14, 0.92) 50%, rgba(14, 15, 16, 0.90) 100%)",
      light: "rgba(255, 255, 255, 0.03)",
      hover: "rgba(255, 255, 255, 0.06)",
    },

    /**
     * Text colors
     * primary:   Main content text
     * secondary: Helper text and placeholders
     */
    text: {
      primary: "rgba(255, 255, 255, 0.92)",
      secondary: "rgba(255, 255, 255, 0.65)",
    },

    /** Warning and important indicators */
    accent: "rgba(160, 165, 170, 0.95)",

    /** Power menu option colors */
    power: {
      shutdown: "rgba(255, 85, 100, 0.95)",
      restart: "rgb(100, 105, 110)",
      sleep: "rgb(80, 140, 200)",
      lock: "rgb(180, 160, 70)",
      signout: "rgb(120, 125, 130)",
    },

    /** Widget styling colors */
    widgets: {
      background: "rgba(100, 105, 110, 0.05)",
      border: "rgba(100, 105, 110, 0.22)",
      hoverBackground: "rgba(100, 105, 110, 0.12)",
    },

    /** Search widget colors */
    search: {
      background: "rgba(12, 13, 14, 0.96)",
      border: "rgba(100, 105, 110, 0.30)",
      shadow: "0 2px 14px rgba(100, 105, 110, 0.12)",
      buttonBackground: "rgba(100, 105, 110, 0.16)",
      buttonHover: "rgba(100, 105, 110, 0.26)",
    },
  },

  /** Typography settings */
  fonts: {
    family: "monospace",
    size: "13px",

    /**
     * Icon sizing
     * md:       Material Design icons
     * fa:       FontAwesome icons
     * oct:      Octicons
     * weather:  Weather icons
     * charging: Battery charging indicator
     */
    icons: {
      scale: {
        md: 1.05,
        fa: 1,
        oct: 1.05,
        weather: 1.15,
      },
      charging: "7px",
    },
  },

  /** Layout Configuration */
  layout: {
    /** Corner radius (rounded or squared) */
    radius: {
      container: { style: "rounded", value: "12px" },
      workspace: { style: "rounded", value: "5px" },
      shortcut: { style: "rounded", value: "5px" },
      control: { style: "rounded", value: "6px" },
    },

    /** Button styling */
    buttons: {
      workspace: {
        padding: "4px 9px",
        margin: "0 3px",
        border: "0px",
        scale: "1.05",
      },
      shortcut: {
        padding: "3px 8px",
        margin: "0 1px",
        border: "1px",
        scale: "1.03",
      },
      control: {
        padding: "4px 9px",
        margin: "0 3px",
        border: "1px",
        scale: "1.05",
      },
    },

    /** Power menu styling */
    powerMenu: {
      hoverBrightness: 1.15,
      hoverScale: 1.1,
      buttonGap: "3px",
      buttonPadding: "4px 6px",
      buttonMargin: "0 1px",
    },

    /** Widget containers */
    widgets: {
      useContainers: true,
      borderRadius: "6px",
      padding: "3px 8px",
      gap: "3px",
      hoverEffects: true,
    },

    /** Search widget styling */
    search: {
      buttonPadding: "4px 8px",
      buttonHeight: "26px",
      borderRadius: "6px",
      animationSpeed: "0.3s",
      expandedWidth: "220px",
    },

    /** Main taskbar styling */
    bar: {
      height: "36px",
      borderWidth: "2px",
      borderStyle: "solid",
      shadow: "0 0 10px -2px rgba(100, 105, 110, 0.20), 0 2px 8px rgba(0,0,0,0.50)",
      blurStrength: "16px",
    },

    /**
     * Visual separators between elements
     * color: null uses primary light by default
     */
    separator: {
      width: "1px",
      color: null,
      opacity: 0.6,
      hoverOpacity: 0.9,
    },
  },

  /** Animation settings */
  animations: {
    enable: true,

    /** Animation durations in milliseconds */
    speed: {
      fast: 150,
      normal: 250,
      slow: 350,
    },

    /**
     * Easing functions
     * hover: For small UI changes
     * menu:  For menu animations
     */
    easing: {
      hover: "cubic-bezier(0.19, 1, 0.22, 1)",
      menu: "cubic-bezier(0.25, 1, 0.5, 1)",
    },
  },
};

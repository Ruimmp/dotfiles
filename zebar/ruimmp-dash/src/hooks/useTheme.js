import { useEffect } from "react";
import theme from "../../config/theme.js";

export const useTheme = () => {
  useEffect(() => {
    const generateThemeVariables = theme => {
      // Extract RGB components from primary color for use in rgba()
      const extractRGB = color => {
        if (color.startsWith("rgba(")) {
          return color.replace("rgba(", "").split(",").slice(0, 3).join(",");
        } else if (color.startsWith("rgb(")) {
          return color.replace("rgb(", "").split(",").slice(0, 3).join(",");
        } else if (color.startsWith("#")) {
          const r = parseInt(color.slice(1, 3), 16);
          const g = parseInt(color.slice(3, 5), 16);
          const b = parseInt(color.slice(5, 7), 16);
          return `${r}, ${g}, ${b}`;
        }
        return "94, 129, 244"; // Default fallback
      };

      // Ensure border properties include the "px" unit if it's missing
      const ensureUnit = value => {
        if (typeof value === "string" && /^\d+$/.test(value.trim())) {
          return `${value}px`;
        }
        return value;
      };

      const primaryRGB = extractRGB(theme.colors.primary.main);
      const separatorColor = theme.layout.separator?.color || theme.colors.primary.light;

      return {
        // Colors
        "--primary-main": theme.colors.primary.main,
        "--primary-main-rgb": primaryRGB,
        "--primary-light": theme.colors.primary.light,
        "--primary-dark": theme.colors.primary.dark,
        "--background-main": theme.colors.background.main,
        "--background-light": theme.colors.background.light,
        "--background-hover": theme.colors.background.hover,
        // Add RGB value for background hover to use in opacity variations
        "--background-hover-rgb": extractRGB(theme.colors.background.hover),
        "--text-primary": theme.colors.text.primary,
        "--text-secondary": theme.colors.text.secondary,
        "--accent-color": theme.colors.accent,

        // Power menu colors
        "--power-shutdown-color": theme.colors.power.shutdown,
        "--power-restart-color": theme.colors.power.restart,
        "--power-sleep-color": theme.colors.power.sleep,
        "--power-lock-color": theme.colors.power.lock,
        "--power-signout-color": theme.colors.power.signout,

        // Typography
        "--font-family": theme.fonts.family,
        "--font-size": theme.fonts.size,
        "--font-icon-charging": theme.fonts.icons.charging,

        // Icon scales
        "--icon-scale-md": theme.fonts.icons.scale.md,
        "--icon-scale-fa": theme.fonts.icons.scale.fa,
        "--icon-scale-oct": theme.fonts.icons.scale.oct,
        "--icon-scale-weather": theme.fonts.icons.scale.weather,

        // Radius
        "--radius-container":
          theme.layout.radius.container.style === "rounded"
            ? theme.layout.radius.container.value
            : "0",
        "--radius-workspace":
          theme.layout.radius.workspace.style === "rounded"
            ? theme.layout.radius.workspace.value
            : "0",
        "--radius-shortcut":
          theme.layout.radius.shortcut.style === "rounded"
            ? theme.layout.radius.shortcut.value
            : "0",
        "--radius-control":
          theme.layout.radius.control.style === "rounded" ? theme.layout.radius.control.value : "0",

        // Buttons
        "--button-workspace-padding": theme.layout.buttons.workspace.padding,
        "--button-workspace-margin": theme.layout.buttons.workspace.margin,
        "--button-workspace-border": ensureUnit(theme.layout.buttons.workspace.border),
        "--button-workspace-scale": theme.layout.buttons.workspace.scale,

        "--button-shortcut-padding": theme.layout.buttons.shortcut.padding,
        "--button-shortcut-margin": theme.layout.buttons.shortcut.margin,
        "--button-shortcut-border": ensureUnit(theme.layout.buttons.shortcut.border),
        "--button-shortcut-scale": theme.layout.buttons.shortcut.scale,

        "--button-control-padding": theme.layout.buttons.control.padding,
        "--button-control-margin": theme.layout.buttons.control.margin,
        "--button-control-border": ensureUnit(theme.layout.buttons.control.border),
        "--button-control-scale": theme.layout.buttons.control.scale,

        // Power menu
        "--power-hover-brightness": theme.layout.powerMenu.hoverBrightness,
        "--power-hover-scale": theme.layout.powerMenu.hoverScale,
        "--power-button-gap": theme.layout.powerMenu.buttonGap,
        "--power-button-padding": theme.layout.powerMenu.buttonPadding,
        "--power-button-margin": theme.layout.powerMenu.buttonMargin,

        // Widget containers
        "--widget-background": theme.colors.widgets.background,
        "--widget-border": theme.colors.widgets.border,
        "--widget-hover-bg": theme.colors.widgets.hoverBackground,
        "--widget-border-radius": theme.layout.widgets.borderRadius,
        "--widget-padding": theme.layout.widgets.padding,
        "--widget-gap": theme.layout.widgets.gap,

        // Conditionally set hover effects based on the hoverEffects setting
        "--widget-hover-transform": theme.layout.widgets.hoverEffects ? "translateY(-1px)" : "none",
        "--widget-hover-shadow": theme.layout.widgets.hoverEffects
          ? "0 2px 8px rgba(0, 0, 0, 0.2)"
          : "none",
        "--widget-hover-opacity": theme.layout.widgets.hoverEffects ? "1" : "0.9",

        // Bar layout
        "--bar-height": theme.layout.bar?.height || "28px",
        "--border-width": theme.layout.bar?.borderWidth || "2px",
        "--border-style": theme.layout.bar?.borderStyle || "solid",
        "--box-shadow": theme.layout.bar?.shadow || "none",
        "--blur-strength": theme.layout.bar?.blurStrength || "10px",

        // Separator styling
        "--separator-width": theme.layout.separator?.width || "1px",
        "--separator-color": separatorColor,
        "--separator-opacity": theme.layout.separator?.opacity || 0.6,
        "--separator-hover-opacity": theme.layout.separator?.hoverOpacity || 0.9,

        // Animation settings
        "--transition-speed": `${theme.animations?.speed?.normal || 250}ms`,
        "--transition-speed-fast": `${theme.animations?.speed?.fast || 150}ms`,
        "--transition-speed-slow": `${theme.animations?.speed?.slow || 350}ms`,
        "--easing-hover": theme.animations?.easing?.hover || "cubic-bezier(0.19, 1, 0.22, 1)",
        "--easing-menu": theme.animations?.easing?.menu || "cubic-bezier(0.25, 1, 0.5, 1)",

        // Search widget styling
        "--search-background": theme.colors.search?.background || "var(--background-light)",
        "--search-border-color": theme.colors.search?.border || "var(--primary-light)",
        "--search-shadow": theme.colors.search?.shadow || "none",
        "--search-button-background":
          theme.colors.search?.buttonBackground || "var(--primary-light)",
        "--search-button-hover": theme.colors.search?.buttonHover || "var(--primary-main)",
        "--search-button-padding": theme.layout.search?.buttonPadding || "4px 8px",
        "--search-button-height": theme.layout.search?.buttonHeight || "26px",
        "--search-border-radius": theme.layout.search?.borderRadius || "var(--radius-control)",
        "--search-animation-speed": theme.layout.search?.animationSpeed || "0.3s",
        "--search-expanded-width": theme.layout.search?.expandedWidth || "220px",
      };
    };

    const applyTheme = variables => {
      Object.entries(variables).forEach(([property, value]) => {
        document.documentElement.style.setProperty(property, value);
      });
    };

    applyTheme(generateThemeVariables(theme));
  }, []);
};

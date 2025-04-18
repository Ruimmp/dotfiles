import "normalize.css";
import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import * as zebar from "zebar";
import MediaWidget from "./components/media/MediaWidget.jsx";
import WebSearch from "./components/search/WebSearch.jsx";
import Shortcut from "./components/core/Shortcut.jsx";
import PowerMenu from "./components/core/PowerMenu.jsx";
import config from "../config/config.js";
import theme from "../config/theme.js";
import moment from "moment";
import { useTheme } from "./hooks/useTheme";

// Initialize Zebar providers for system monitoring and commands
const providers = zebar.createProviderGroup({
  keyboard: { type: "keyboard" },
  glazewm: { type: "glazewm" },
  cpu: { type: "cpu" },
  date: { type: "date", formatting: "EEE d MMM t" },
  battery: { type: "battery" },
  memory: { type: "memory" },
  weather: { type: "weather" },
  host: { type: "host" },
  media: { type: "media" },
  audio: { type: "audio" },
});

createRoot(document.getElementById("root")).render(<App />);

function App() {
  useTheme();
  const [output, setOutput] = useState(providers.outputMap);

  // Simulate battery when device has none but simulation is enabled
  useEffect(() => {
    if (config.debug?.simulateBattery?.enabled === true && !output.battery) {
      const newOutput = { ...output };
      newOutput.battery = {
        chargePercent: config.debug.simulateBattery.percentage || 50,
        isCharging: config.debug.simulateBattery.isCharging || false,
      };

      setOutput(newOutput);
    }
  }, [output.battery, config.debug?.simulateBattery?.enabled]);

  const [showMediaWidget] = useState(config.media?.enabled !== false);
  const [showShortcuts] = useState(config.shortcuts?.enabled !== false);
  const [showShortcutLabels] = useState(config.shortcuts?.showLabels === true);
  const [showLabelsOnHover] = useState(config.shortcuts?.showLabelsOnHover !== false);
  const [dateFormat, setDateFormat] = useState(config.dateTime.defaultFormat);

  // Theme-based widget appearance settings
  const useWidgetContainers = theme?.layout?.widgets?.useContainers !== false;
  const useWidgetHover = theme?.layout?.widgets?.hoverEffects !== false;

  useEffect(() => {
    providers.onOutput(() => setOutput(providers.outputMap));
  }, []);

  // Battery icon selection based on charge level
  function getBatteryIcon(batteryOutput) {
    if (batteryOutput.chargePercent > 90) return <i className="nf nf-fa-battery_4"></i>;
    if (batteryOutput.chargePercent > 70) return <i className="nf nf-fa-battery_3"></i>;
    if (batteryOutput.chargePercent > 40) return <i className="nf nf-fa-battery_2"></i>;
    if (batteryOutput.chargePercent > 20) return <i className="nf nf-fa-battery_1"></i>;
    return <i className="nf nf-fa-battery_0"></i>;
  }

  // Weather icon selection based on conditions
  function getWeatherIcon(weatherOutput) {
    switch (weatherOutput.status) {
      case "clear_day":
        return <i className="nf nf-weather-day_sunny"></i>;
      case "clear_night":
        return <i className="nf nf-weather-night_clear"></i>;
      case "cloudy_day":
        return <i className="nf nf-weather-day_cloudy"></i>;
      case "cloudy_night":
        return <i className="nf nf-weather-night_alt_cloudy"></i>;
      case "light_rain_day":
        return <i className="nf nf-weather-day_sprinkle"></i>;
      case "light_rain_night":
        return <i className="nf nf-weather-night_alt_sprinkle"></i>;
      case "heavy_rain_day":
        return <i className="nf nf-weather-day_rain"></i>;
      case "heavy_rain_night":
        return <i className="nf nf-weather-night_alt_rain"></i>;
      case "snow_day":
        return <i className="nf nf-weather-day_snow"></i>;
      case "snow_night":
        return <i className="nf nf-weather-night_alt_snow"></i>;
      case "thunder_day":
        return <i className="nf nf-weather-day_lightning"></i>;
      case "thunder_night":
        return <i className="nf nf-weather-night_alt_lightning"></i>;
      default:
        return <i className="nf nf-weather-day_sunny"></i>;
    }
  }

  // Determine whether to show app shortcuts section
  const shouldShowShortcuts =
    showShortcuts &&
    output.glazewm &&
    config.shortcuts.items &&
    Array.isArray(config.shortcuts.items) &&
    config.shortcuts.items.length > 0;

  // Determine if battery widget should be shown
  const shouldShowBattery =
    config.battery.enabled && output.battery !== undefined && output.battery !== null;

  return (
    <div className="app">
      {/* Left section - Logo and shortcuts */}
      <div className="left">
        <div className="box">
          <div className={`logo ${shouldShowShortcuts ? "with-shortcuts" : ""}`}>
            <i className="nf nf-custom-windows"></i>
            {output.host?.hostname} | {output.host?.friendlyOsVersion}
          </div>

          {shouldShowShortcuts && (
            <div className="shortcuts-container">
              {config.shortcuts.items.map((shortcut, index) => (
                <Shortcut
                  key={index}
                  commandRunner={output.glazewm.runCommand}
                  commands={[
                    shortcut.workspace ? `focus --workspace ${shortcut.workspace}` : null,
                    `shell-exec ${shortcut.command}`,
                  ].filter(Boolean)}
                  iconClass={shortcut.icon}
                  name={showShortcutLabels ? shortcut.name : ""}
                  showOnHover={!showShortcutLabels && showLabelsOnHover ? shortcut.name : ""}
                />
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Center section - Workspaces */}
      <div className="center">
        <div className="box">
          {output.glazewm && (
            <div className="workspaces">
              {output.glazewm.currentWorkspaces.map(workspace => (
                <button
                  className={`workspace ${workspace.hasFocus && "focused"} ${workspace.isDisplayed && "displayed"}`}
                  onClick={() => output.glazewm.runCommand(`focus --workspace ${workspace.name}`)}
                  key={workspace.name}
                >
                  {workspace.displayName ?? workspace.name}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Right section - System widgets and controls */}
      <div className="right">
        <div className="box">
          {/* Web search */}
          {config.search.enabled && output.glazewm && (
            <WebSearch
              commandRunner={output.glazewm.runCommand}
              explorerPath={config.search.explorerPath}
            />
          )}

          {/* Media player */}
          {config.media.enabled && showMediaWidget && output.media && output.audio ? (
            <div className="widget-container no-bg media-widget-container">
              <MediaWidget mediaProvider={output.media} audioProvider={output.audio} />
            </div>
          ) : null}

          {/* Date and time */}
          <div
            className="widget-container no-bg date-widget"
            onMouseEnter={() => {
              setDateFormat(config.dateTime.hoverFormat);
            }}
            onMouseLeave={() => {
              setDateFormat(config.dateTime.defaultFormat);
            }}
          >
            <i className="nf nf-md-calendar_month"></i>
            <button className="clean-button">{moment(output.date?.now).format(dateFormat)}</button>
          </div>

          {/* Weather */}
          {config.weather.enabled && output.weather && (
            <div
              className={`widget-container stat-widget ${useWidgetContainers ? "with-bg" : ""} ${
                useWidgetHover ? "widget-hover" : ""
              }`}
            >
              <div className="weather">
                {getWeatherIcon(output.weather)}
                <span>
                  {config.weather.unit === "fahrenheit"
                    ? `${Math.round(output.weather.fahrenheitTemp)}°F`
                    : `${Math.round(output.weather.celsiusTemp)}°C`}
                </span>
              </div>
            </div>
          )}

          {/* CPU stats */}
          {config.systemStats.enabled && config.systemStats.widgets.cpu.enabled && output.cpu && (
            <div
              className={`widget-container stat-widget ${useWidgetContainers ? "with-bg" : ""} ${
                useWidgetHover ? "widget-hover" : ""
              }`}
            >
              <button
                className="cpu clean-button"
                onClick={() => output.glazewm.runCommand("shell-exec taskmgr")}
              >
                <i className="nf nf-oct-cpu"></i>
                <span
                  className={
                    config.systemStats.widgets.cpu.warningThreshold !== false &&
                    output.cpu.usage > config.systemStats.widgets.cpu.warningThreshold
                      ? "high-usage"
                      : ""
                  }
                >
                  {Math.round(output.cpu.usage)}%
                </span>
              </button>
            </div>
          )}

          {/* Memory stats */}
          {config.systemStats.enabled &&
            config.systemStats.widgets.memory.enabled &&
            output.memory && (
              <div
                className={`widget-container stat-widget ${useWidgetContainers ? "with-bg" : ""} ${
                  useWidgetHover ? "widget-hover" : ""
                }`}
              >
                <button
                  className="memory clean-button"
                  onClick={() => output.glazewm.runCommand("shell-exec taskmgr")}
                >
                  <i className="nf nf-fae-chip"></i>
                  <span
                    className={
                      config.systemStats.widgets.memory.warningThreshold !== false &&
                      output.memory.usage > config.systemStats.widgets.memory.warningThreshold
                        ? "high-usage"
                        : ""
                    }
                  >
                    {Math.round(output.memory.usage)}%
                  </span>
                </button>
              </div>
            )}

          {/* Battery */}
          {shouldShowBattery && (
            <div
              className={`widget-container stat-widget ${useWidgetContainers ? "with-bg" : ""} ${
                useWidgetHover ? "widget-hover" : ""
              }`}
            >
              <div className="battery">
                {getBatteryIcon(output.battery)}
                {output.battery.isCharging && config.battery.showChargingIcon && (
                  <i className="nf nf-md-lightning_bolt charging-icon"></i>
                )}
                <span
                  className={
                    output.battery.chargePercent < config.battery.warningThreshold
                      ? "low-battery"
                      : ""
                  }
                >
                  {Math.round(output.battery.chargePercent)}%
                </span>
              </div>
            </div>
          )}

          {/* Keyboard layout */}
          {output.keyboard && config.keyboard.enabled && (
            <div
              className={`widget-container stat-widget ${useWidgetContainers ? "with-bg" : ""} ${
                useWidgetHover ? "widget-hover" : ""
              }`}
            >
              <div className="keyboard">
                <i className="nf nf-fa-keyboard"></i>
                <span>{config.keyboard.layoutOverride || output.keyboard.layout}</span>
              </div>
            </div>
          )}

          {/* Window manager controls */}
          {output.glazewm && config.windowManager.enableTilingDirection && (
            <button
              className={`tiling-direction nf ${
                output.glazewm.tilingDirection === "horizontal"
                  ? "nf-md-swap_horizontal"
                  : "nf-md-swap_vertical"
              }`}
              onClick={() => output.glazewm.runCommand("toggle-tiling-direction")}
              title={`Switch to ${output.glazewm.tilingDirection === "horizontal" ? "vertical" : "horizontal"} tiling`}
            ></button>
          )}

          {/* Power menu */}
          {output.glazewm && config.powerMenu.enabled && (
            <PowerMenu commandRunner={output.glazewm.runCommand} />
          )}
        </div>
      </div>
    </div>
  );
}

import React, { useState, useEffect } from "react";
import config from "../../../config/config.js";

const PowerMenu = ({ commandRunner }) => {
  const [showMenu, setShowMenu] = useState(false);
  const [animationClass, setAnimationClass] = useState("");

  const direction = config.powerMenu?.direction || "left";
  const alwaysOpen = config.powerMenu?.alwaysOpen || false;
  const autoCloseTimeout = config.powerMenu?.autoCloseTimeout;
  const powerOptions = config.powerMenu?.options || [
    "shutdown",
    "restart",
    "sleep",
    "lock",
    "signout",
  ];

  useEffect(() => {
    if (showMenu) {
      setAnimationClass("menu-visible");
    } else {
      setAnimationClass("menu-hidden");
    }
  }, [showMenu]);

  useEffect(() => {
    let timer;
    if (showMenu && autoCloseTimeout !== false) {
      timer = setTimeout(() => setShowMenu(false), autoCloseTimeout || 5000);
    }
    return () => {
      if (timer) clearTimeout(timer);
    };
  }, [showMenu, autoCloseTimeout]);

  const powerCommands = {
    shutdown: "shell-exec shutdown /s /t 0",
    restart: "shell-exec shutdown /r /t 0",
    sleep: "shell-exec rundll32.exe powrprof.dll,SetSuspendState 0,1,0",
    lock: "shell-exec rundll32.exe user32.dll,LockWorkStation",
    signout: "shell-exec shutdown /l",
  };

  const powerIcons = {
    shutdown: "nf-md-power",
    restart: "nf-md-restart",
    sleep: "nf-md-power_sleep",
    lock: "nf-md-lock",
    signout: "nf-md-logout",
  };

  return (
    <div
      className={`power-menu-container direction-${direction} ${alwaysOpen ? "always-open" : ""}`}
    >
      {!alwaysOpen && (
        <button
          className={`power-menu-button ${showMenu ? "active" : ""}`}
          onClick={() => setShowMenu(!showMenu)}
          title="Power Menu"
        >
          <i className={`nf ${showMenu ? "nf-md-close" : "nf-md-power"}`}></i>
        </button>
      )}

      {(alwaysOpen || showMenu) && (
        <div className={`power-options-inline ${animationClass}`}>
          {powerOptions.map(option => (
            <button
              key={option}
              className="power-option-inline clean-button"
              onClick={() => commandRunner(powerCommands[option])}
              title={option.charAt(0).toUpperCase() + option.slice(1)}
            >
              <i className={`nf ${powerIcons[option]}`}></i>
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

export default PowerMenu;

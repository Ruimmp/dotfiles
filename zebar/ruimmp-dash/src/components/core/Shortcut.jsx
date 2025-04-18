import React from "react";

const Shortcut = ({ commandRunner, commands, iconClass, name, showOnHover }) => {
  const handleClick = () => {
    for (const command of commands) {
      commandRunner(command);
    }
  };

  const isIconOnly = !name || name.trim() === "";
  const className = `shortcut ${isIconOnly ? "icon-only" : ""} ${showOnHover ? "has-hover-label" : ""}`;

  return (
    <button className={className} onClick={handleClick} title={name || showOnHover}>
      <i className={`nf ${iconClass}`}></i>
      {(name || showOnHover) && <span>{name || showOnHover}</span>}
    </button>
  );
};

export default Shortcut;

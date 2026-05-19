import React, { useState, useRef } from "react";
import config from "../../../config/config.js";

const WebSearch = ({ commandRunner, explorerPath, placeholder }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [expanded, setExpanded] = useState(false);
  const inputRef = useRef(null);

  const handleSearch = e => {
    e.preventDefault();
    if (searchQuery.trim()) {
      const encodedSearch = encodeURIComponent(searchQuery);
      const searchUrl = `https://www.google.com/search?q=${encodedSearch}`;

      commandRunner(`shell-exec ${explorerPath} "${searchUrl}"`);
      setSearchQuery("");
      setExpanded(false);
    }
  };

  const toggleSearch = () => {
    setExpanded(!expanded);
    if (!expanded) {
      setTimeout(() => inputRef.current?.focus(), 0);
    }
  };

  return (
    <div className="search-widget">
      <div className={`search-inline-container ${expanded ? "expanded" : ""}`}>
        {expanded ? (
          <form className="search-input-container" onSubmit={handleSearch}>
            <input
              ref={inputRef}
              type="text"
              placeholder={placeholder || config.search.placeholder || "Search..."}
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
            />
            <button type="submit" className="search-button">
              <i className="nf nf-fa-search"></i>
            </button>
            <button type="button" className="close-button" onClick={toggleSearch}>
              <i className="nf nf-md-close"></i>
            </button>
          </form>
        ) : (
          <button className="search-icon" onClick={toggleSearch}>
            <i className="nf nf-fa-search"></i>
          </button>
        )}
      </div>
    </div>
  );
};

export default WebSearch;

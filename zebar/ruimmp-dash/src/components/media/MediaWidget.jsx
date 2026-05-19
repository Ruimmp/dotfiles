import React, { useEffect, useState, createRef, useMemo } from "react";
import config from "../../../config/config.js";

const MediaWidget = ({ mediaProvider, audioProvider }) => {
  const [song, setSong] = useState("fetching...");
  const [showSettings, setShowSettings] = useState(false);
  const widgetRef = createRef();

  const shouldShowControls = config.media.display.showControlsOnHover;

  const maxSongLength = useMemo(() => {
    if (window.innerWidth > 1920) return 30; // Ultra-wide
    if (window.innerWidth > 1600) return 20; // Large screens
    if (window.innerWidth > 1280) return 15; // Medium screens
    if (window.innerWidth > 768) return 10; // Small screens
    return 8; // Very small screens
  }, []);

  async function updateSong() {
    const tempSong = mediaProvider?.currentSession?.isPlaying
      ? mediaProvider.currentSession.title
      : "...";
    setSong(tempSong);
  }

  useEffect(() => {
    updateSong();
  }, [mediaProvider]);

  async function previousSong() {
    mediaProvider.previous();
  }

  async function playPause() {
    mediaProvider.togglePlayPause();
  }

  async function skipSong() {
    mediaProvider.next();
  }

  const truncatedSong = useMemo(() => {
    if (!song || song === "fetching..." || song === "..." || song === "Error") {
      return song;
    }

    const adjustedMaxLength = showSettings ? Math.max(6, maxSongLength - 12) : maxSongLength;

    if (song.length > adjustedMaxLength) {
      return song.substring(0, adjustedMaxLength) + "...";
    }
    return song;
  }, [song, maxSongLength, showSettings]);

  return (
    <button
      ref={widgetRef}
      className="media-widget-button clean-button"
      onMouseEnter={() => setShowSettings(true)}
      onMouseLeave={() => setShowSettings(false)}
      title={song}
    >
      <div className="media-content">
        <i className="nf nf-md-music media-icon"></i>
        <span className="song-title">{truncatedSong}</span>
      </div>

      {shouldShowControls && showSettings && !["fetching...", "Error", "..."].includes(song) && (
        <div className="media-controls-container">
          <button
            className="clean-button media-control-button"
            onClick={async e => {
              e.stopPropagation();
              await previousSong();
              setTimeout(async () => await updateSong(), 1000);
            }}
          >
            <i className="nf nf-md-skip_previous"></i>
          </button>
          <button
            className="clean-button media-control-button"
            onClick={async e => {
              e.stopPropagation();
              await playPause();
              setTimeout(async () => await updateSong(), 1000);
            }}
          >
            <i className="nf nf-md-play_pause"></i>
          </button>
          <button
            className="clean-button media-control-button"
            onClick={async e => {
              e.stopPropagation();
              await skipSong();
              setTimeout(async () => await updateSong(), 1000);
            }}
          >
            <i className="nf nf-md-skip_next"></i>
          </button>
        </div>
      )}
    </button>
  );
};

export default MediaWidget;

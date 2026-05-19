mkcd() {
  local dir_name="$1"
  if [[ -z "$dir_name" ]]; then
    echo "Usage: mkcd <directory_name>"
    return 1
  fi
  mkdir -p "$dir_name" && cd "$dir_name"
}

open() {
  local path="${1:-.}"
  if [[ -e "$path" ]]; then
    explorer "$path"
  else
    echo "Path '$path' does not exist."
  fi
}

mate() {
  local path="${1:-.}"
  if [[ -e "$path" ]]; then
    if command -v notepads.exe &>/dev/null; then
      notepads.exe "$path"
    else
      echo "Using notepad (notepads.exe not found)"
      notepad.exe "$path"
    fi
  else
    echo "Path '$path' does not exist."
  fi
}

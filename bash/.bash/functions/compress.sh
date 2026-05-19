compress() {
  if [ -f "$1" ]; then
    local input_file="$1"
    local base_name

    base_name=$(basename "$input_file" .mp4)

    local output_dir="."
    if [ -n "$2" ]; then
      output_dir="$2"
      if [ ! -d "$output_dir" ]; then
        read -p "'$output_dir' does not exist. Create it? (y/n) " answer
        if [[ $answer == [Yy]* ]]; then
          mkdir -p "$output_dir"
        else
          echo "Compression cancelled."
          return 1
        fi
      fi
    fi

    local output_file="$output_dir/${base_name}_compressed.mp4"
    local ffmpeg_overwrite_flag="-n"

    if [ -f "$output_file" ]; then
      echo "File '$output_file' already exists."

      read -p "Do you want to overwrite it? (y/n) " overwrite

      if [[ $overwrite == [Yy]* ]]; then
        echo "Overwriting existing file..."
        ffmpeg_overwrite_flag="-y"
      else
        while true; do
          read -p "Enter a custom name (without .mp4): " custom_name

          output_file="$output_dir/${custom_name}.mp4"

          if [ ! -f "$output_file" ]; then
            echo "Output file set to '$output_file'"
            break
          else
            echo "File '$output_file' already exists. Choose another name."
          fi
        done
      fi
    fi

    echo "Compressing '$input_file' -> '$output_file'..."
    ffmpeg $ffmpeg_overwrite_flag -i "$input_file" -c:v libx264 -preset slow -crf 18 -c:a copy "$output_file"

    if [ $? -eq 0 ]; then
      echo "Compression completed: '$output_file'"
    else
      echo "Compression failed."
    fi
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

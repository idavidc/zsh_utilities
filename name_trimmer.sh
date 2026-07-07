#!/bin/zsh

# Directory to search for files (current directory by default)
dir="${1:-.}"

# Loop through all files in the specified directory
for file in "$dir"/*; do
  # Check if the file contains "] "
  if [[ "$file" == *"] "* ]]; then
    # Extract the part after "] "
    new_name="${file#*] }"
    
    # Rename the file
    mv "$file" "$new_name"
    echo "Renamed: '$file' -> '$new_name'"
  fi
done


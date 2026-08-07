#!/bin/zsh

# ============================================================================
# File Renamer: Strips "] " prefix from filenames
# ============================================================================
# Usage: $(basename "$0") [OPTIONS] [DIRECTORY]
#
# Renames files containing "] " by removing everything up to and including "] ".
#
# Options:
#   -n, --dry-run   Preview changes without actually renaming files
#   -h, --help      Show this help message and exit
#
# Arguments:
#   DIRECTORY       Directory to search (defaults to current directory)
#
# Examples:
#   $(basename "$0")              # Rename files in current directory
#   $(basename "$0") /path/to/dir # Rename files in specified directory
#   $(basename "$0") -n           # Preview changes in current directory
#   $(basename "$0") --dry-run /path/to/dir # Preview changes in specified directory
#
# Notes:
#   - Uses 'mv -n' to prevent overwriting existing files
#   - Files where the target name already exists will be skipped
#   - Only processes regular files (directories are ignored)
# ============================================================================

SCRIPT_NAME=$(basename "$0")

usage() {
  cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] [DIRECTORY]

Renames files containing "] " by removing everything up to and including "] ".

Options:
  -n, --dry-run   Preview changes without actually renaming files
  -h, --help      Show this help message and exit

Arguments:
  DIRECTORY       Directory to search (defaults to current directory)

Examples:
  $SCRIPT_NAME              # Rename files in current directory
  $SCRIPT_NAME /path/to/dir # Rename files in specified directory
  $SCRIPT_NAME -n           # Preview changes in current directory
  $SCRIPT_NAME --dry-run /path/to/dir # Preview changes in specified directory

Notes:
  - Uses 'mv -n' to prevent overwriting existing files
  - Files where the target name already exists will be skipped
  - Only processes regular files (directories are ignored)
EOF
}

# Handle help flag first
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Parse dry-run flag and directory
dry_run=false
if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
  dry_run=true
  dir="${2:-.}"
else
  dir="${1:-.}"
fi

# Validate target directory
if [[ ! -d "$dir" ]]; then
  echo "Error: Directory '$dir' does not exist." >&2
  exit 1
fi

# Loop through all files in the specified directory
for file in "$dir"/*; do
  # Skip if glob matched nothing (empty directory)
  [[ -e "$file" ]] || continue
  
  # Only process regular files (skip directories, symlinks, etc.)
  [[ -f "$file" ]] || continue

  # Check if the file contains "] "
  if [[ "$file" == *"] "* ]]; then
    # Extract the part after "] "
    new_name="${file#*] }"
    
    # Skip if extraction resulted in an empty name
    if [[ -z "$new_name" ]]; then
      echo "Skipped (empty target): '$file'"
      continue
    fi

    if [[ "$dry_run" == true ]]; then
      echo "[DRY RUN] Would rename: '$file' -> '$new_name'"
    else
      # mv -n prevents overwriting existing files
      if mv -n "$file" "$new_name"; then
        echo "Renamed: '$file' -> '$new_name'"
      else
        echo "Skipped (target already exists): '$file' -> '$new_name'"
      fi
    fi
  fi
done

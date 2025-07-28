#!/bin/bash
# Franky Weber Faust -- July 2025 -- weber08weber@gmail.com -- https://loredata.com.br
# Copyright (C) 2025 Franky Faust
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#
# More info and git repo: https://github.com/FrankyWeber/golden-scripts
#
# The current script version is 20250728
#
# History :
#
# 20250728 - Franky Faust - Initial release with retention and extension variables to search and delete backups or any sort of files from specified directories.
#

# ==============================================================================
#
# Script: cleanup_backups.sh
#
# Description: This script removes old backup files from specified directories based on a retention period.
#
# Usage: ./cleanup_backups.sh
# ==============================================================================

# --- Configs ---

# Set the number of days to keep the backup files.
# Files older than this will be removed.
RETENTION_DAYS=45

# A list of directories to clean up.
# Add or remove directories as needed.
TARGET_DIRECTORIES=("/zfs/backup1" "/zfs/backup2")

# A list of file extensions to target for deletion.
# Use "*" to target all files regardless of extension.
# Example: FILE_EXTENSIONS=("*.bak" "*.zip" "*.tar.gz" "*.bkup" "*.bkp")
FILE_EXTENSIONS=("*.bkup")

# --- Script Logic ---

# Get the current date for logging purposes
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$CURRENT_DATE] Starting backup cleanup process..."
echo "--------------------------------------------------"

# Loop through each specified directory
for DIR in "${TARGET_DIRECTORIES[@]}"; do
  # Check if the directory exists
  if [ -d "$DIR" ]; then
    echo "Processing directory: $DIR"

    # Loop through each specified file extension
    for EXT in "${FILE_EXTENSIONS[@]}"; do
      echo "  -> Searching for files with extension '$EXT' older than $RETENTION_DAYS days..."

      # Find and delete the files.
      # The '-mtime +$RETENTION_DAYS' option finds files modified more than RETENTION_DAYS ago.
      # The '-type f' ensures we only target files, not directories.
      # The '-exec rm -v {} \;' executes the 'rm' command on each file found.
      # The '-v' option for 'rm' makes it verbose, showing which files are being removed.
      find "$DIR" -type f -name "$EXT" -mtime +"$RETENTION_DAYS" -exec rm -v {} \;

    done
    echo "Finished processing directory: $DIR"
  else
    echo "Warning: Directory '$DIR' not found. Skipping."
  fi
  echo "--------------------------------------------------"
done

echo "[$CURRENT_DATE] Backup cleanup process finished."

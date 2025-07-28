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

# --- Log Configuration ---

# Directory to store log files.
LOG_DIR="/var/log/backup_cleanup"

# Log file retention in days.
LOG_RETENTION_DAYS=7

# --- Log Management Function ---

manage_log_rotation() {
    # Exit if the log directory doesn't exist.
    if [ ! -d "$LOG_DIR" ]; then
        echo "Log directory '$LOG_DIR' not found. Skipping log rotation."
        return
    fi

    echo "--- Running Log Rotation ---"
    # Find and delete compressed log files (.gz) older than LOG_RETENTION_DAYS.
    find "$LOG_DIR" -type f -name "*.log.gz" -mtime +"$LOG_RETENTION_DAYS" -print -exec rm -f {} \;

    # Find and compress uncompressed log files (.log) older than 1 day.
    find "$LOG_DIR" -type f -name "*.log" -mtime +0 -print -exec gzip {} \;
    echo "--- Log Rotation Finished ---"
}

# --- Script Execution ---

# Define the log file for the current execution (e.g., cleanup-2025-07-28.log).
LOG_FILE="$LOG_DIR/cleanup-$(date +%Y-%m-%d).log"

# Run the log rotation and management function.
# This is done before redirecting output to ensure rotation messages are captured.
manage_log_rotation | tee -a "$LOG_FILE"

# Redirect all subsequent standard output and standard error to the log file,
# while also displaying it on the console using 'tee'.
exec > >(tee -a "${LOG_FILE}") 2>&1

# --- Main Cleanup Logic ---

CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$CURRENT_DATE] Starting backup cleanup process..."
echo "--------------------------------------------------"
echo "File Retention: $RETENTION_DAYS days"
echo "Target Directories: ${TARGET_DIRECTORIES[*]}"
echo "Target Extensions: ${FILE_EXTENSIONS[*]}"
echo "--------------------------------------------------"


# Loop through each specified directory
for DIR in "${TARGET_DIRECTORIES[@]}"; do
  # Check if the directory exists
  if [ -d "$DIR" ]; then
    echo "Processing directory: $DIR"

    # Loop through each specified file extension
    for EXT in "${FILE_EXTENSIONS[@]}"; do
      echo "  -> Searching for files matching '$EXT' older than $RETENTION_DAYS days..."

      # Find and delete the files.
      # The '-mtime +$RETENTION_DAYS' option finds files modified more than RETENTION_DAYS ago.
      # The '-type f' ensures we only target files, not directories.
      # The '-exec rm -v {} \;' executes the 'rm' command on each file found and prints the name.
      find "$DIR" -type f -name "$EXT" -mtime +"$RETENTION_DAYS" -exec rm -v {} \;

    done
    echo "Finished processing directory: $DIR"
  else
    echo "Warning: Directory '$DIR' not found. Skipping."
  fi
  echo "--------------------------------------------------"
done

echo "[$CURRENT_DATE] Backup cleanup process finished."

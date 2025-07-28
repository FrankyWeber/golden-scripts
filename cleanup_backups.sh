#!/bin/bash

# ==============================================================================
#
#          FILE:  cleanup_backups.sh
#
#         USAGE:  ./cleanup_backups.sh
#
#   DESCRIPTION:  This script removes old backup files from specified
#                 directories based on a retention period.
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Your Name
#  ORGANIZATION:
#       CREATED:  07/28/2025 11:55
#      REVISION:  1.0
#
# ==============================================================================

# --- Configuration ---

# Set the number of days to keep the backup files.
# Files older than this will be removed.
RETENTION_DAYS=45

# An array of directories to clean up.
# Add or remove directories as needed.
TARGET_DIRECTORIES=("/zfs/backup1" "/zfs/backup2")

# An array of file extensions to target for deletion.
# Use "*" to target all files regardless of extension.
# Example: FILE_EXTENSIONS=("*.bak" "*.zip" "*.tar.gz")
FILE_EXTENSIONS=("*.bak")

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

#!/bin/bash
set -eou pipefail

# Log rotation script

# Define log directory
LOG_DIR="./logs"
DAYS_TO_KEEP=0
DATE=$(date +"%Y-%m-%d")

if [[ ! -d "$LOG_DIR" ]]; then
    echo "Log directory does not exist. Exiting..."
    exit 1
fi


echo "Rotating logs....."

# Loop through all files ending with .log in the log directory
for logfile in "$LOG_DIR"/*.log; do
    echo "Processing $logfile"
    # Check if the file actually exists
    # This prevents errors when no .log files are found
    [[ -e $logfile ]] || continue
    # Extract just the filename from the full path
    # Example: /var/log/app.log => app.log
    filename=$(basename "$logfile")
    # Print the extracted filename (useful for debugging/logging)
    echo "$filename"
    # Rename (archive) the log file by appending the current date
    # Example: app.log => app.log.2026-01-30
    mv "$logfile" "$LOG_DIR/$filename.$DATE"
    # Recreate an empty log file with the original name
    # This ensures the application can continue writing logs
    touch "$logfile"
    # Inform that the log file has been rotated (renamed)
    echo "Compressed $logfile"
done

echo "compressing rotated logs...."
find "$LOG_DIR" -name "*.log.*" -mtime +$DAYS_TO_KEEP -exec gzip {} \;
# -exec => execute a command on the files found
# {} => placeholder for the files found
# \; => end of the command

echo "Removing logs older than $DAYS_TO_KEEP days...."
find "$LOG_DIR" -name "*.log.*" -mtime +$DAYS_TO_KEEP -delete
# -mtime => modification time
# +$DAYS_TO_KEEP => files older than $DAYS_TO_KEEP days
# -delete => delete the files

echo "Log rotation completed"


# Don't run on script, add to cron job

# GOTO terminal and type crontab -e
# Add the following line
# 0 0 * * * /path/to/log-rotation.sh
# This will run the script every day at midnight
# Save and exit

# 0 => minute
# 0 => hour
# * => day of the month
# * => month
# * => day of the week

# To check the cron job
# crontab -l
# To remove the cron job
# crontab -r





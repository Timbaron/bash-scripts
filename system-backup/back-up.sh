#!/bin/bash
set -euo pipefail

# Variables
BACKUP_SOURCE="$HOME/Desktop/Learning"
BACKUP_DIR="$HOME/Desktop/backups"
BUCKET_NAME="my-backups-bucket"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="home_backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"
# Create backup archive

echo "Creating backup archive..."

# tar -czf => create a compressed archive
# --exclude => exclude files from the archive
# "$HOME/docker_course" => exclude the docker course directory
# "$HOME/devops-pipeline" => exclude the devops pipeline directory
# "$BACKUP_SOURCE" => the directory to backup
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
  --exclude="$HOME/docker_course" \
  --exclude="$HOME/devops-pipeline" \
  "$BACKUP_SOURCE"
 
# Check if the backup archive was created successfully
if [[ ! -f "$BACKUP_DIR/$ARCHIVE_NAME" ]]; then
  echo "Backup archive creation failed"
  exit 1
fi

# Upload backup to S3
echo "Uploading backup to S3..."

# aws s3 cp => copy the backup archive to S3
# "$BACKUP_DIR/$ARCHIVE_NAME" => the backup archive to copy
# "s3://$BUCKET_NAME/$ARCHIVE_NAME" => the S3 bucket to copy to
aws s3 cp \
  "$BACKUP_DIR/$ARCHIVE_NAME" \
  "s3://$BUCKET_NAME/$ARCHIVE_NAME"

# Print that the backup completed successfully
echo "Backup completed successfully at $(date)"

# Remove backup files older than 7 days
# find => find files
# "$BACKUP_DIR" => the directory to search in
# -type f => only files
# -mtime +7 => files modified more than 7 days ago
# -delete => delete the files
find "$BACKUP_DIR" -type f -mtime +7 -delete

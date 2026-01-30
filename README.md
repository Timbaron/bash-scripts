# Bash Scripting

This repository contains bash scripts for DevOps tasks, including log analysis and system setup automation.

## Scripts

### 1. Log Analysis Script (`analyse-logs-script/analyse-logs.sh`)

This script analyzes log files to identify critical errors and generate a summary report.

**Features:**
- Scans a defined log directory for `.log` files modified in the last 24 hours.
- Searches for specific error patterns: `ERROR`, `FATAL`, `CRITICAL`.
- Counts occurrences of each error pattern.
- Generates a detailed report file (`log_report_analysis.txt`).
- Alerts on the console if the number of errors exceeds a defined threshold (default: 2).

**Usage:**
```bash
./analyse-logs-script/analyse-logs.sh
```

**Configuration:**
- `LOG_DIR`: Directory to scan for logs.
- `REPORT_FILE`: Path where the analysis report is saved.
- `LOG_THRESHOLD`: Threshold for high-error alerts.

### 2. System Setup Script (`system-setup/setup.sh`)

An idempotent script to automate the setup of a developer environment on macOS or Linux.

**Features:**
- **OS Detection**: Automatically detects macOS or Linux.
- **Package Installation**: Checks and installs missing packages (`brew`, `node`, `git`).
- **Environment Configuration**: Configures `PATH` and other environment variables in `.zshrc` or `.bashrc`.
- **Git Repositories**: Clones specified git repositories if they don't already exist.
- **Database Setup**: Sets up test databases and users for PostgreSQL or MySQL.
  - Supports `postgres` (default) and `mysql`.
  - Creates databases (`testdb1`, `testdb2`) and users (`testuser1`, `testuser2`).
  - Grants necessary privileges.

**Usage:**
# General setup (defaults to PostgreSQL)
./system-setup/setup.sh

# Or run specific functions manually locally if needed (by sourcing):
# source ./system-setup/setup.sh
# setup_databases "mysql"

### 3. Log Rotation Script (`log-rotation/log-rotation.sh`)

This script manages log files by separating valid logs from old ones, compressing them to save space, and deleting logs older than a specified retention period.

**Features:**
- **Rotation**: Renames `.log` files with a date stamp (e.g., `app.log.2023-10-27`) and recreates the original empty log file.
- **Compression**: Compresses rotated logs using `gzip` to save disk space.
- **Cleanup**: Deletes compressed logs older than a configurable number of days (default: 0 for testing, typically 7+).

**Usage:**
```bash
./log-rotation/log-rotation.sh
```

**Automated Scheduling (Cron):**
To run this daily at midnight:
```bash
0 0 * * * /path/to/log-rotation.sh >> /path/to/log-rotation.log 2>&1
```

**Configuration:**
- `LOG_DIR`: Directory containing the log files (default: `./logs`).
- `DAYS_TO_KEEP`: Number of days to retain old logs.

### 4. System Backup Script (`system-backup/back-up.sh`)

Automates the backup of critical directories to a local archive and uploads it to an AWS S3 bucket for offsite storage.

**Features:**
- **Compression**: Archives the source directory into a `.tar.gz` file.
- **Exclusions**: Customizable exclusion of large or unnecessary directories.
- **Cloud Upload**: Uploads the archive to a specified AWS S3 bucket.
- **Retention**: Deletes local backup archives older than 7 days.

**Prerequisites:**
- AWS CLI installed and configured (`aws configure`).

**Usage:**
```bash
./system-backup/back-up.sh
```

**Configuration:**
- `BACKUP_SOURCE`: The directory path to back up.
- `BACKUP_DIR`: Local path to store generated archives.
- `BUCKET_NAME`: Target AWS S3 bucket name.

### 5. Server Health Check Script (`server-health-check/server_health_check.sh`)

A cross-platform script (Linux & macOS) to monitor server health metrics including CPU usage, memory usage, and uptime. It uses OS-specific commands to gather data and alerts if usage exceeds defined thresholds.

**Features:**
- **Cross-Platform Support**: Automatically detects and runs appropriate commands for Linux and macOS.
- **Metric Monitoring**: Checks CPU usage, Memory percentage, and System Uptime.
- **Alerting**: Triggers alerts if CPU or Memory usage exceeds configurable thresholds (default: CPU > 80%, RAM > 75%).

**Usage:**
```bash
./server-health-check/server_health_check.sh
```

**Configuration:**
- `CPU_THRESHOLD`: Percentage threshold for CPU usage alerts.
- `MEM_THRESHOLD`: Percentage threshold for Memory usage alerts.


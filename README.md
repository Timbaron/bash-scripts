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
```bash
# General setup (defaults to PostgreSQL)
./system-setup/setup.sh

# Or run specific functions manually locally if needed (by sourcing):
# source ./system-setup/setup.sh
# setup_databases "mysql"
```

**Key Functions:**
- `install_if_missing`: Generic function to check and install packages.
- `configure_env`: Updates shell configuration files.
- `setup_databases [type]`: Sets up the specified database type.


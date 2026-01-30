#!/usr/bin/env bash
# -------------------------------------------
# Server Health Check Script (Linux + macOS)
# Checks CPU usage, memory usage, uptime
# Alerts if usage exceeds thresholds
# -------------------------------------------

set -euo pipefail
# -e : exit on error
# -u : exit on using undefined variables
# -o pipefail : exit if any part of a pipeline fails

# ---------------------------
# CONFIGURATION
# ---------------------------

CPU_THRESHOLD=80   # CPU usage percentage threshold
MEM_THRESHOLD=75   # Memory usage percentage threshold

# ---------------------------
# DETECT OS
# ---------------------------

OS_TYPE="$OSTYPE"  # Bash built-in variable that detects OS

# ---------------------------
# LINUX SYSTEM METRICS
# ---------------------------

if [[ "$OS_TYPE" == "linux-gnu"* ]]; then
  # CPU usage (Linux)
  # top -bn1 : batch mode, 1 iteration (script-friendly)
  # grep "Cpu(s)" : filter CPU info line
  # awk '{print 100 - $8}' : calculate usage = 100 - idle%
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

  # Memory usage (Linux)
  # free : displays memory stats
  # awk '/Mem:/ { printf("%.0f"), $3/$2 * 100 }' : calculate used/total %
  MEM_USAGE=$(free | awk '/Mem:/ { printf("%.0f"), $3/$2 * 100 }')

  # Uptime (Linux)
  # uptime -p : human-readable uptime
  UPTIME=$(uptime -p)

# ---------------------------
# MACOS SYSTEM METRICS
# ---------------------------

elif [[ "$OS_TYPE" == "darwin"* ]]; then
  # CPU usage (macOS)
  # top -l 1 : run once (macOS top)
  # awk '/CPU usage/ {print $3}' : extract user CPU %
  # sed 's/%//' : remove % symbol for numeric comparison
  CPU_USAGE=$(top -l 1 | awk '/CPU usage/ {print $3}' | sed 's/%//')

  # Memory usage (macOS)
  # vm_stat : returns memory stats in pages
  # awk calculates: used = active + wired + speculative
  # total = used + free
  # percentage = used / total * 100
  MEM_USAGE=$(vm_stat | awk '
  /Pages active/ {active=$3}
  /Pages wired/ {wired=$4}
  /Pages speculative/ {spec=$3}
  /Pages free/ {free=$3}
  END {
    used = active + wired + spec
    total = used + free
    printf "%.0f", (used/total)*100
  }')

  # Uptime (macOS)
  UPTIME=$(uptime)

# ---------------------------
# UNSUPPORTED OS
# ---------------------------

else
  echo "Unsupported operating system: $OS_TYPE"
  exit 1
fi

# ---------------------------
# DISPLAY STATUS
# ---------------------------

echo "Server Health Check"
echo "-------------------"
echo "OS Type: $OS_TYPE"
echo "CPU Usage: ${CPU_USAGE}%"
echo "Memory Usage: ${MEM_USAGE}%"
echo "Uptime: $UPTIME"

# ---------------------------
# ALERT IF THRESHOLD EXCEEDED
# ---------------------------

# CPU Alert
# ${CPU_USAGE%.*} removes decimal part for integer comparison
if (( ${CPU_USAGE%.*} > CPU_THRESHOLD )); then
  echo "ALERT: CPU usage exceeded ${CPU_THRESHOLD}%"
fi

# Memory Alert
if (( MEM_USAGE > MEM_THRESHOLD )); then
  echo "ALERT: Memory usage exceeded ${MEM_THRESHOLD}%"
fi

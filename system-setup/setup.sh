set -euo pipefail
IFS=$'\n\t'

# set -e => If any command fails, the script stops immediately
# set -u => If any variable is undefined, the script stops immediately
# set -o pipefail => If any command in a pipeline fails, the script stops immediately
# IFS=$'\n\t' => Controls how Bash splits words


# VARIABLES DEFINITIONS


# Detect OS (Linux / macOS)
# Install required software (specific versions)
# Configure environment variables
# Clone repositories
# Set up test databases
# Be safe to run multiple times (idempotent)
# Fail fast on errors
# echo "🚀 Starting developer environment setup..."

# Detect User OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [[ "$OSTYPE" == "linux"* ]]; then
        OS="Linux"
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi

}

detect_os

echo "$OS"

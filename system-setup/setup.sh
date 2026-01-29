#!/bin/bash
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
# USAGE
# detect_os

# Check if a package is installed and install if missing
install_if_missing() {
    local package="$1"
    local install_command="${2:-brew install $package}"
    # :- => “use this default if $2 is unset or empty”
    # ${2:-brew install $package} => if $2 is unset or empty, use "brew install $package"
    # ${2:-} => if $2 is unset or empty, use ""

    if ! command -v "$package" &> /dev/null; then
        echo "$package is not installed. Installing..."
        eval "$install_command"
    else 
        echo "$package is installed."
    fi

    # command -v => Checks if command exists
    # &> /dev/null => Redirects both stdout and stderr to /dev/null (suppresses output)
    # ! => Negates the result of the command
    # eval => Executes the command
    # local => Creates a local variable
}

# Check and install Homebrew
install_if_missing "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Check and install Node and Git
install_if_missing "node"
install_if_missing "git"

# echo "$OS"

# Configure environment variables
configure_env() {
    local shell_config
    if [[ "$SHELL" == */zsh ]]; then
        shell_config="$HOME/.zshrc"
    else
        shell_config="$HOME/.bashrc"
    fi

    echo "Configuring environment in $shell_config..."
    
    # Add Homebrew to PATH if needed
    if [[ "$OS" == "Linux" ]]; then
       if ! grep -q "/home/linuxbrew/.linuxbrew/bin" "$shell_config"; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$shell_config"
       fi
    elif [[ "$OS" == "macOS" ]]; then
       if ! grep -q "/opt/homebrew/bin" "$shell_config"; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$shell_config"
       fi
    fi

    # -q => Suppresses output
    # grep -q => Suppresses output
    # grep -q "/opt/homebrew/bin" "$shell_config" => Checks if "/opt/homebrew/bin" exists in "$shell_config"
    # ! => Negates the result of the command
    # >> => Appends to the file
    # eval => Executes the command
    # shellenv => Prints the shell environment variables
}

# Ensure OS is detected before configuring env
detect_os
configure_env


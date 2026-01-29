#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# set -e => If any command fails, the script stops immediately
# set -u => If any variable is undefined, the script stops immediately
# set -o pipefail => If any command in a pipeline fails, the script stops immediately
# IFS=$'\n\t' => Controls how Bash splits words


# Detect OS (Linux / macOS)
# Install required software (specific versions)
# Configure environment variables
# Clone repositories
# Set up test databases

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

# Clone repositories
clone_repos() {
    local repos=(
        "https://github.com/timothyakiode/system-setup.git"
        "https://github.com/timothyakiode/system-setup.git"
    )

    for repo in "${repos[@]}"; do
        local repo_name="${repo##*/}"
        # ${repo##*/} => Removes everything up to and including the last slash "/"
        # example: ${https://github.com/timothyakiode/system-setup.git##*/}
        # output: system-setup.git
        if [[ ! -d "$repo_name" ]]; then
            # -d => Checks if the file exists and is a directory.
            # -f => Checks if the file exists and is a regular file (not a directory).
            # -e => Checks if the file exists (either as a file or a directory).
            # -s => Checks if the file exists and has a size greater than zero.
            # -r => Checks if the file exists and is readable.
            # -w => Checks if the file exists and is writable.
            # -x => Checks if the file exists and is executable.
            # ! => Negates the result of the command
            echo "Cloning $repo_name..."
            git clone "$repo"
        else
            echo "$repo_name already exists."
        fi
    done
}

# Set up test databases
setup_databases() {
    local db_type="${1:-postgres}"
    echo "Setting up $db_type databases..."
    
    if [[ "$db_type" == "postgres" ]]; then
        # Check and install PostgreSQL (using psql to check)
        install_if_missing "psql" "brew install postgresql"

        # Create test databases
        createdb -U postgres testdb1 || echo "testdb1 may already exist"
        createdb -U postgres testdb2 || echo "testdb2 may already exist"
        # -U postgres => runs the command as the postgres superuser.
        
        # Create test users
        createuser -U postgres testuser1 || echo "testuser1 may already exist"
        createuser -U postgres testuser2 || echo "testuser2 may already exist"
        # -U postgres => run as postgres superuser

        # Grant privileges
        psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE testdb1 TO testuser1"
        psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE testdb2 TO testuser2"

        # U => run as postgres superuser
        # -c "SQL_COMMAND" => execute a SQL statement

    elif [[ "$db_type" == "mysql" ]]; then
        # Check and install MySQL
        install_if_missing "mysql"

        # Create databases
        mysql -e "CREATE DATABASE IF NOT EXISTS testdb1;"
        mysql -e "CREATE DATABASE IF NOT EXISTS testdb2;"

        # Create users and grant privileges
        mysql -e "CREATE USER IF NOT EXISTS 'testuser1'@'localhost' IDENTIFIED BY 'password';"
        mysql -e "GRANT ALL PRIVILEGES ON testdb1.* TO 'testuser1'@'localhost';"
        # -e => execute a SQL statement
        
        mysql -e "CREATE USER IF NOT EXISTS 'testuser2'@'localhost' IDENTIFIED BY 'password';"
        mysql -e "GRANT ALL PRIVILEGES ON testdb2.* TO 'testuser2'@'localhost';"
        
        mysql -e "FLUSH PRIVILEGES;"
    else
        echo "Unsupported database type: $db_type"
        exit 1
    fi
}

# USAGE (Maintain order of execution)
# detect_os
# install_if_missing "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
# install_if_missing "node"
# install_if_missing "git"
# configure_env
# clone_repos
# setup_databases "postgres"
# setup_databases "mysql" 
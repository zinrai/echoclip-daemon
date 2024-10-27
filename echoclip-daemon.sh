#!/bin/bash

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
check_requirements() {
    local missing_commands=()

    if ! command_exists nc; then
        missing_commands+=("nc")
    fi

    if ! command_exists pbcopy; then
        missing_commands+=("pbcopy")
    fi

    if [ ${#missing_commands[@]} -ne 0 ]; then
        echo "Error: The following required commands are missing:"
        printf '  - %s\n' "${missing_commands[@]}"
        echo "Please install these commands and try again."
        exit 1
    fi
}

# Cleanup child processes
cleanup() {
    echo "Terminating clipboard daemon and child processes..."
    pkill -P $$
    exit 0
}

# Daemonize itself
daemonize() {
    # Terminate any existing process
    pkill -f "nc -l 127.0.0.1 12345 | pbcopy"

    # Re-execute itself with nohup
    if [ "$1" != "daemon" ]; then
        echo "Starting as a daemon..."
        nohup "$0" daemon > /dev/null 2>&1 &
        exit 0
    fi
}

main() {
    # Set up trap to catch termination signals
    trap cleanup SIGINT SIGTERM

    # Start the clipboard monitoring in the background
    while true; do
        nc -l 127.0.0.1 12345 | pbcopy &
        wait $!
    done
}

# Check requirements before executing the script
check_requirements

# Script execution
if [ "$1" = "daemon" ]; then
    main
else
    daemonize "$@"
fi

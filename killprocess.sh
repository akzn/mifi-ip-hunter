#!/bin/bash

script_name="openclash-check-ping"

# Get all PIDs of the running script (+.sh)
script_pids=$(pgrep -f "$script_name.sh")

if [ -n "$script_pids" ]; then
    echo "Found PIDs: $script_pids"
    
    # Kill all instances of the script
    for pid in $script_pids; do
        kill "$pid"
        echo "Script with PID $pid killed successfully."
    done
else
    echo "Script is not currently running."
fi

# Remove the lock file
rm -f "/tmp/$script_name.lock"
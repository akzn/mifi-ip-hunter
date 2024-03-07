#!/bin/bash

script_name="openclash-check-ping"

# Get the PID of the running script (+.sh)
script_pid=$(pgrep -f "$script_name.sh")

if [ -n "$script_pid" ]; then
    echo "Found PID: $script_pid"
    
    # Kill the script
    kill "$script_pid"
    
    echo "Script killed successfully."
else
    echo "Script is not currently running."
fi

# remove the lock file
rm -f "/tmp/$script_name.lock"
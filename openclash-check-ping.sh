#!/bin/bash

# Replace these with your OpenClash API URL and token
API_URL="http://0.0.0.0:9090"
API_TOKEN="123456"

# Maximum allowed failed attempts
MAX_FAILED_ATTEMPTS=3

# Specify the proxy name
PROXY_NAME="Failover%20Eth1"

# Set a lock file path
LOCK_FILE="/tmp/openclash-check-ping.lock"

# Check if lock file exists
if [ -e "$LOCK_FILE" ]; then
    echo "Script is already running. Exiting."
    exit 0
fi

# Create a lock file
touch "$LOCK_FILE"

# New endpoint URL
DELAY_CHECK_URL="${API_URL}/proxies/${PROXY_NAME}/delay?timeout=8000&url=http%3A%2F%2Fwww.gstatic.com%2Fgenerate_204"

# Function to handle delay check and rerun
check_delay_and_rerun() {
    local delay_check_response
    local delay
    local message
    local time=$(date "+%H:%M:%S")
    local count=0  # Counter to track failed attempts

    while [ "$count" -lt "$MAX_FAILED_ATTEMPTS" ]; do
        # Make the delay check API call
        delay_check_response=$(curl -s "${DELAY_CHECK_URL}" -H "Authorization: Bearer ${API_TOKEN}")

        # Check if curl failed to connect
        if [ $? -ne 0 ]; then
            echo "Exiting iphunter due to Curl failed to connect. probably Openclash is not running."
            rm -f "$LOCK_FILE"
            exit 1
        fi

        sleep 3

        # Parse JSON using jshn.sh
        . /usr/share/libubox/jshn.sh
        json_load "$delay_check_response"

        # Use json_get_var to get values
        json_get_var delay delay
        json_get_var message message

        # Check if there is a delay value or an error message
        if [ -n "$delay" ]; then
            echo "[$(date "+%H:%M:%S")] Delay for ${PROXY_NAME}: $delay ms"
            break  # Exit loop on successful delay check
        else
            echo "attemt $((count+1))/$MAX_FAILED_ATTEMPTS"
            # current time
            echo "[$(date "+%H:%M:%S")] Delay check for ${PROXY_NAME} failed. Message: $message"
            # ((count++))
            sleep 5
        fi

        count=$((count+1))
    done

    # If delay check fails 5 times, attempt to reconnect
    if [ "$count" -eq "$MAX_FAILED_ATTEMPTS" ]; then
        
        # only reconnect if message contain "Timeout"
        if [[ "$message" == *"Timeout"* ]]; then
            echo "delay check for ${PROXY_NAME} $MAX_FAILED_ATTEMPTS times got 'timeout' status. Reconnecting..."
            bash modem iphunterb1b3
        else
            echo "Failed to check delay for ${PROXY_NAME} $MAX_FAILED_ATTEMPTS times. Message: $message"
        fi

        # run the script again
        echo "Recheck connection..."
        check_delay_and_rerun
    fi
}

# Initial run
check_delay_and_rerun

# Remove the lock file
rm -f "$LOCK_FILE"

exit 0

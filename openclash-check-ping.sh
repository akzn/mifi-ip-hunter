#!/bin/bash

# Replace these with your OpenClash API URL and token
API_URL="http://0.0.0.0:9090"
API_TOKEN="123456"

# Specify the proxy name
PROXY_NAME="Failover%20Eth1"

# Set a lock file path
LOCK_FILE="/tmp/openclash-check-ping.lock"

# Check if lock file exists
if [ -e "$LOCK_FILE" ]; then
    echo "Script is already running. Exiting."
    exit 1
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

    # Make the delay check API call
    delay_check_response=$(curl -s "${DELAY_CHECK_URL}" -H "Authorization: Bearer ${API_TOKEN}")

    sleep 3

    # Parse JSON using jshn.sh
    . /usr/share/libubox/jshn.sh
    json_load "$delay_check_response"

    # Use json_get_var to get values
    json_get_var delay delay
    json_get_var message message

    # Check if there is a delay value or an error message
    if [ -n "$delay" ]; then
        echo "Delay for ${PROXY_NAME}: $delay ms"
    else
        echo "Delay check for ${PROXY_NAME} failed. Message: $message"
        bash modem iphunter
        sleep 10
        # rerun this script
        check_delay_and_rerun
    fi
}

# Initial run
check_delay_and_rerun

# Remove the lock file
rm -f "$LOCK_FILE"
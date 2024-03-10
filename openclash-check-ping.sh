#!/bin/bash

# Replace these with your OpenClash API URL and token
API_URL="http://0.0.0.0:9090"
API_TOKEN="123456"

# Specify the proxy name
# PROXY_NAME="Failover%20Eth1"
PROXY_NAME="1.%20ETH.1"

# Set a lock file path
LOCK_FILE="/tmp/openclash-check-ping.lock"

# Check if lock file exists
if [ -e "$LOCK_FILE" ]; then
    echo "Script is already running. Exiting."
    exit 0
fi

# Create a lock file
touch "$LOCK_FILE"

# endpoint URL
# DELAY_CHECK_URL="${API_URL}/proxies/${PROXY_NAME}/delay?timeout=8000&url=http%3A%2F%2Fwww.gstatic.com%2Fgenerate_204"

# Healthcheck url
HEALTH_CHECK_URL="${API_URL}/providers/proxies/${PROXY_NAME}/healthcheck"

# Proxies Health Status
HEALTH_STATUS_URL="${API_URL}/providers/proxies/${PROXY_NAME}";

# Function to handle delay check and rerun
check_delay_and_rerun() {
    local delay_check_response
    local delays=()  # Array to store delays
    local last_delay=0  # Flag to check if any delay is greater than 0
    local time=$(date +"%T")

    # Health check first
    health_check_response=$(curl -s "${HEALTH_CHECK_URL}" -H "Authorization: Bearer ${API_TOKEN}")
    
    sleep 5

    # Make the delay check API call
    delay_check_response=$(curl -s "${HEALTH_STATUS_URL}" -H "Authorization: Bearer ${API_TOKEN}")

    # sleep 5

    # Parse JSON using jq
    delays=($(echo "$delay_check_response" | jq -r '.proxies[].history[].delay'))

    for delay in "${delays[@]}"; do
        # Check if the delay is greater than 0
        if ((delay > 0)); then
            last_delay=$delay
        fi
    done

    if ((last_delay > 0)); then
        # echo the delay
        echo "Delay for proxies ${PROXY_NAME}: $last_delay ms at time $time"
    else
        # iphunter
        echo "Delay check for proxies ${PROXY_NAME} at time $time failed."
        bash modem reconnect
        sleep 10
        # rerun this script
        check_delay_and_rerun
    fi
}

# Initial run
check_delay_and_rerun

# Remove the lock file
rm -f "$LOCK_FILE"

exit 0
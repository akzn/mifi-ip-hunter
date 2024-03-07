# Huawei MIFI Auto-Reconnect Script for OpenWRT

## Overview

This script automates the reconnection of a Huawei MIFI device when a specified proxy has no ping. It is designed for OpenWRT environments with OpenClash installed.

## Prerequisites

1. OpenWRT installed.
2. OpenClash installed.
3. Huawei MIFI device (Tested on 5577).

## Installation

1. Copy the entire folder to your OpenWRT device.
2. Open the file "openclash-check-ping.sh" and set the `PROXY_NAME` variable to your desired proxy name. You can find the proxy name through YACD (Yet Another Clash Dashboard).
   > Avoid using the proxy provider as `PROXY_NAME` because it will result in a "404" response.
3. Test the script by running:
   ```bash
   bash openclash-check-ping.sh
   ```
4. Set up a cron/scheduler. Below is an example for a 1-minute interval:
   ```bash
   * * * * * cd [folder/path] && bash openclash-check-ping.sh
   ```

## Notes

- Ensure that your Huawei MIFI device is compatible (tested on 5577).
- Adjust the cron interval based on your requirements.
- Avoid using the proxy provider as `PROXY_NAME` to prevent a "404" response.

## Notes++
### stop process if loop happened
- print PID
  ```
  busybox ps | busybox grep 'openclash-check-ping.sh'
  ```
- kill process
  ```
  busybox kill -9 $CRON_PID
  ```
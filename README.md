# Huawei MIFI Auto-Reconnect Script for OpenWRT

## Overview

This script automates the reconnection of a Huawei MIFI device when a specified OPENCLASH proxy has no ping. It is designed for OpenWRT environments with OpenClash installed.

## Prerequisites

1. OpenWRT installed.
2. OpenClash installed.
3. Huawei MIFI device (Tested on 5577).

## Installation

1. Copy the entire folder to your OpenWRT device.
2. Open the file "openclash-check-ping.sh" and set the `PROXY_NAME` variable to your desired proxy name. You can find the proxy name through YACD (Yet Another Clash Dashboard).
   example :
   ![image](https://github.com/akzn/mifi-ip-hunter/assets/40191741/327dee05-a504-4717-80c1-bf1abe6cd258)


   > Avoid using the proxy provider as `PROXY_NAME` because it will result in a "404" response.
3. Still on openclash-check-ping.sh file, set your yacd password/secret on variable `token`
4. Test the script by running:
   ```bash
   bash openclash-check-ping.sh
   ```
5. Set up a cron/scheduler. Below is an example for a 1-minute interval:
   ```bash
   * * * * * cd [folder/path] && bash openclash-check-ping.sh
   ```
6. to kill this script 
   ```
   cd /folder/path 
   bash killprocess.sh
   ```

## Notes

1. **Device Compatibility:**
   - Ensure compatibility with your Huawei MIFI device (tested on e5577, e3372).
   - The default modem password is `admin`. If you use a different password, update it in the `modem` file under the variable `pass`.
   - Currently, the script supports a single modem with the IP address prefix 192.168. If your configuration differs, modify the IP prefix in the `modem` file under the variable `ipmodem`.

2. **Support for Dual Modems:**
   - To support dual modems, copy this repository into another folder and adjust the IP prefix in each copy om file "modem" to 192.168.x and 192.168.y, where x represents the subnet for modem 1 and y for modem 2.
   - Change the lockfile name on `openclash-check-ping.sh` (line 11) for each folder/modem to set the desired configurations.

3. **Cron Job Interval:**
   - Adjust the cron interval according to your specific requirements.

4. **Proxy Provider Name:**
   - Avoid using the proxy provider as `PROXY_NAME` to prevent receiving a "404" response. Choose a unique name to ensure proper functionality.

## Notes++
### stop process if loop happened and kill bash is failed
- print PID
  ```
  busybox ps | busybox grep 'openclash-check-ping.sh'
  ```
- kill process
  ```
  busybox kill -9 $CRON_PID
  ```
- remove lock file
  ```
  rm -rf /tmp/openclash-check-ping.lock
  ```

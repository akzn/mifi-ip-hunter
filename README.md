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

- Ensure that your Huawei MIFI device is compatible (tested on 5577).
  - default modem password is `admin`. If you have different password, change it on file `modem`, search for variable `pass` 
  - for now its only supporting a single modem with ip 192.168 prefix. If you have different configuration, change the IP prefix on file `modem` variable `ipmodem`.
  - you can use this to support dual modem with copying this repo into another folder and change each the IP prefix to 192.168.x and 192.168.y with x is subnet modem 1 and y is subnet modem 2.
- Adjust the cron interval based on your requirements.
- Avoid using the proxy provider as `PROXY_NAME` to prevent a "404" response.

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

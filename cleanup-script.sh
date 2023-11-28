#!/bin/bash

# Setzen Sie die ursprüngliche /etc/watchdog.conf zurück
cp /etc/watchdog.conf.default /etc/watchdog.conf

# Neustart des Watchdog-Dienstes auf dem Host
nsenter --target 1 --mount --uts --ipc --net --pid -- service watchdog restart

#!/bin/bash

# Überprüfen, ob die erforderlichen Umgebungsvariablen gesetzt sind
if [ -z "$HOST_NAME" ]  || [ -z "$USER_NAME" ] ; then
    echo "Die Umgebungsvariablen USER_NAME HOST_NAME müssen gesetzt sein."
    exit 1
fi

# Define the host and user
HOST=$HOST_NAME 
USER=$USER_NAME

# Setzen Sie die ursprüngliche /etc/watchdog.conf zurück
cp /etc/watchdog.conf.default /host_etc/watchdog.conf

# Command to stop the watchdog service over SSH
STOP_CMD="ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa $USER@$HOST sudo systemctl stop watchdog"

# Command to start the watchdog service over SSH
START_CMD="ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa $USER@$HOST sudo systemctl start watchdog"

# Execute the stop command
echo "Stopping watchdog service on the host..."
$STOP_CMD

# Wait a bit to ensure the service has time to stop
sleep 2

# Execute the start command
echo "Starting watchdog service on the host..."
$START_CMD

#!/bin/bash

# Überprüfen, ob die erforderlichen Umgebungsvariablen gesetzt sind
if [ -z "$WATCHDOG_FILE" ] || [ -z "$WATCHDOG_CHANGE" ]  || [ -z "$HOST_NAME" ]  || [ -z "$USER_NAME" ] ; then
    echo "Die Umgebungsvariablen WATCHDOG_FILE WATCHDOG_CHANGE USER_NAME HOST_NAME müssen gesetzt sein."
    exit 1
fi

# Define the host and user
HOST=$HOST_NAME 
USER=$USER_NAME

# Definiert die Cleanup-Funktion
cleanup() {
    echo "SIGTERM-Signal empfangen, rufe cleanup-script.sh auf..."
    /cleanup-script.sh
}

# SIGTERM-Falle einrichten
trap cleanup SIGTERM


# Ändern der /etc/watchdog.conf mit den Umgebungsvariablen
sed -i "s|#file=.*|file=$WATCHDOG_FILE|" /host_etc/watchdog.conf
sed -i "s|#change=.*|change=$WATCHDOG_CHANGE|" /host_etc/watchdog.conf

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

# Keep the container running
tail -f /dev/null


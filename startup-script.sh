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

# Command to restart watchdog service over SSH
SSH_CMD="ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa $USER@$HOST systemctl restart watchdog"

# Execute the command
echo "Restarting watchdog service on the host..."
$SSH_CMD

# Keep the container running
tail -f /dev/null


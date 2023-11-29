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
cp /etc/watchdog.conf.default /etc/watchdog.conf

# Command to restart watchdog service over SSH
SSH_CMD="ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa $USER@$HOST systemctl restart watchdog"

# Execute the command
echo "Restarting watchdog service on the host..."
$SSH_CMD

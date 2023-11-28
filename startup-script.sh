#!/bin/bash

# Definiert die Cleanup-Funktion
cleanup() {
    echo "SIGTERM-Signal empfangen, rufe cleanup-script.sh auf..."
    /cleanup-script.sh
}

# SIGTERM-Falle einrichten
trap cleanup SIGTERM

# Überprüfen, ob die erforderlichen Umgebungsvariablen gesetzt sind
if [ -z "$WATCHDOG_FILE" ] || [ -z "$WATCHDOG_CHANGE" ]; then
    echo "Die Umgebungsvariablen WATCHDOG_FILE und WATCHDOG_CHANGE müssen gesetzt sein."
    exit 1
fi

# Ändern der /etc/watchdog.conf mit den Umgebungsvariablen
sed -i "s|#file=.*|file=$WATCHDOG_FILE|" /host_etc/watchdog.conf
sed -i "s|#change=.*|change=$WATCHDOG_CHANGE|" /host_etc/watchdog.conf

# Neustart des Watchdog-Dienstes
nsenter --target 1 --mount --uts --ipc --net --pid -- service watchdog restart

# Halten Sie den Container am Laufen
tail -f /dev/null

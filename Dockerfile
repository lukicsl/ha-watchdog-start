FROM debian:latest

# Installieren Sie erforderliche Tools (nsenter könnte nötig sein)
RUN apt-get update && apt-get install -y util-linux

# Fügen Sie Ihre Skripte hinzu
COPY startup-script.sh /startup-script.sh
COPY cleanup-script.sh /cleanup-script.sh

# Setzen Sie Berechtigungen für die Skripte
RUN chmod +x /startup-script.sh
RUN chmod +x /cleanup-script.sh

# Setzen Sie das Start-Skript als Einstiegspunkt
ENTRYPOINT ["/startup-script.sh"]

# SIGTERM-Signal behandeln
CMD ["/cleanup-script.sh"]

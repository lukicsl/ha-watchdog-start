# ha-watchdog
# ha-watchdog-start

docker run --rm --entrypoint cat lukics/ha-watchdog-start /root/.ssh/id_rsa.pub | tee -a ~/.ssh/authorized_keys

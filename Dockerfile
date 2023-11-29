FROM debian:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install required tools 
RUN apt-get update && apt-get install -y \
    util-linux \
    openssh-client

# Generate SSH keys (with no passphrase for automation - be cautious with security!)
RUN ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -q -N ""

# Copy startup and cleanup scripts
COPY startup-script.sh /startup-script.sh
COPY cleanup-script.sh /cleanup-script.sh

# Set execute permissions on the scripts
RUN chmod +x /startup-script.sh
RUN chmod +x /cleanup-script.sh

# Set the entrypoint to the startup script
ENTRYPOINT ["/bin/bash", "/startup-script.sh"]

# Handle the SIGTERM signal
CMD ["/cleanup-script.sh"]

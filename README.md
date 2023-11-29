# Watchdog Container Project

## Overview

This project consists of a Docker container designed to manage the `watchdog` service on a host system using SSH. The container is equipped with scripts to modify the `watchdog` configuration and restart the service remotely. It uses SSH for secure communication with the host.

## Features

- **Remote Service Management**: Control the `watchdog` service on a remote host.
- **SSH Key Based Authentication**: Securely manage services using SSH keys for authentication.
- **Signal Handling**: Gracefully handle shutdown signals for clean resource management.

## Setup

### Building the Docker Image

To build the Docker image, use the following command:

```bash
docker build -t your_image_name .
```
Replace `your_image_name` with your preferred name for the Docker image.

### Generating SSH Keys

The container generates SSH keys during the build process. These keys are used to authenticate with the host system securely.

### Copying SSH Public Key to Host

To allow the container to communicate with the host, you need to copy the SSH public key to the host's `~/.ssh/authorized_keys` file.

1. **Extract the Public Key**: After building the container, run it and extract the public key.

    ```bash
    docker run --rm --entrypoint cat your_image_name /root/.ssh/id_rsa.pub
    ```

2. **Copy the Key to the Host**: Append the copied key to your host's `~/.ssh/authorized_keys` file.

    ```bash
    echo 'copied_public_key' >> ~/.ssh/authorized_keys
    ```
    or
   ```bash
   docker run --rm --entrypoint cat lukics/ha-watchdog-start /root/.ssh/id_rsa.pub | tee -a ~/.ssh/authorized_keys
   ```
    Replace `copied_public_key` with the actual key content.

### Running the Container

Run the container with the necessary environment variables:

```bash
docker run -d -e WATCHDOG_FILE='/path/to/watchdog' -e WATCHDOG_CHANGE='1' -e USER_NAME='your_username' -e HOST_NAME='your_host' your_image_name
```
Replace the environment variable values with the actual configuration details.

## Environment Variables

- `WATCHDOG_FILE`: Path to the watchdog file to be monitored.
- `WATCHDOG_CHANGE`: Change threshold for the watchdog.
- `USER_NAME`: Username for SSH authentication on the host.
- `HOST_NAME`: Hostname or IP address of the host.

## Signal Handling

The container is designed to handle the SIGTERM signal for graceful shutdown. It ensures that cleanup actions are executed before the container stops.

## Security Considerations

Handle the generated SSH keys securely. Ensure that the `authorized_keys` file on the host has the correct permissions:

```bash
chmod 600 ~/.ssh/authorized_keys
```
This step is crucial to maintaining the security of the SSH connection.

## Using the Container

1. **Start the Container**: 

    Use the `docker run` command with the necessary environment variables:

    ```bash
    docker run -d -e WATCHDOG_FILE='/path/to/file' -e WATCHDOG_CHANGE='1' -e USER_NAME='username' -e HOST_NAME='host_ip' your_image_name
    ```

    Replace `'/path/to/file'`, `'1'`, `'username'`, `'host_ip'`, and `your_image_name` with your specific values.

2. **Stopping the Container**:

    When you stop the container, it will execute the `cleanup-script.sh`:

    ```bash
    docker stop your_container_name
    ```

3. **Logs and Monitoring**:

    To check the logs and monitor the activities of your container:

    ```bash
    docker logs your_container_name
    ```



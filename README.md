# Docker Image for Le Wagon Bootcamp

## Configure
1. Copy the sample environment-variable file to a new file named `.env`:
    ```bash
    cp sample-env .env
    ```
2. Fill in values for all variables in your `.env` file. For `USER`, give your Linux user name.

## Build
1. Create a named volume for your container's home directory:
    ```bash
    sudo docker volume create --name=home-volume
    ```
2. Now pull the image and build a container with it:
    ```bash
    sudo docker-compose up -d
    ```

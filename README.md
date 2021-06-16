# Docker Image for Le Wagon Bootcamp

## Configure
1. Copy the sample environment-variable file to a new file named `.env`:
    ```bash
    cp sample-env .env
    ```
2. Fill in values for all variables in your `.env` file. For `USER`, give your Linux user name.

## Create a container
1. Pull the image and build a container with it:
    ```bash
    sudo docker-compose up -d
    ```
2. Run the post-installation script on your Docker **host**:
    ```bash
    bash post-install-host.sh
    ```
    You will now have a terminal opened in the Docker container.
3. In the Docker **container**, run the post-installation script:
    ```bash
    cd ~ && bash post-install.sh
    ```

## Issues
- There is still an issue with locales not being set correctly in the built image.

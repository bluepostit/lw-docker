#!/bin/bash

# Your GitHub user name
GITHUB_USERNAME='CHANGE THIS VALUE'
# The path to the bound mount of the container's home directory
CONTAINER_MOUNTED_HOME_PATH='CHANGE THIS VALUE'

docker-compose up -d

# Change ownership of the mounted home directory from root to you
sudo chown -R `whoami` $CONTAINER_MOUNTED_HOME_PATH

touch $CONTAINER_MOUNTED_HOME_PATH/.zshrc

# Clone your dotfiles repo into the container's ~/code/ directory
gh repo clone $GITHUB_USERNAME/dotfiles $CONTAINER_MOUNTED_HOME_PATH/code/dotfiles

# Copy the post-install script into the container:
cp ./post-install.sh $CONTAINER_MOUNTED_HOME_PATH/

# Open a zsh terminal inside the container
docker exec -ti -uwagon lewagon zsh

# Next, run `post-install.sh` in the terminal you just opened.

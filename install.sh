#!/bin/bash

help()
{
  # Display help message
  echo "Install lw-bootcamp Docker container."
  echo
  echo "Usage: $0 -g <GitHub user name> -p <HOME directory>"
  echo
  echo "Options:"
  echo "-g <GitHub user name>    Will be used as a base directory to clone your"
  echo "                         dotfiles directory as <home>/code/dotfiles."
  echo "-p <HOME directory>      The directory on the Docker HOST which will be"
  echo "                         bind-mounted to the container's HOME directory."
  echo "-h                       Show this help message."
}

# Check if help arg is included:
while getopts ":g:p:h" opt; do
  if [ $opt == "h" ]; then
    help
    exit 1
  fi
done;
OPTIND=0

while getopts ":g:p:" option; do
  case "${option}" in
    g)
      GITHUB_USERNAME=${OPTARG}
      ;;
    p)
      CONTAINER_MOUNTED_HOME_PATH=${OPTARG}
      ;;
    \?)
      echo "Invalid option: ${OPTARG}"
      help
      exit
      ;;
  esac
done

# Check that both variables are set and not blank
if [ -z "$GITHUB_USERNAME" ]; then
  echo "GitHub user name must be provided."
  help
  exit 1
elif [ -z "$CONTAINER_MOUNTED_HOME_PATH" ]; then
  echo "Container mounted home path must be provided."
  help
  exit 1
fi

echo "Creating container with docker-compose..."
docker-compose up -d

# Change ownership of the mounted home directory from root to you
echo "Changing owner of ${CONTAINER_MOUNTED_HOME_PATH} to ${USER}..."
sudo chown -R $USER $CONTAINER_MOUNTED_HOME_PATH

# Create this file to avoid the zsh post-install config prompt on first login
touch $CONTAINER_MOUNTED_HOME_PATH/.zshrc

# Clone your dotfiles repo into the container's ~/code/ directory
echo "Cloning your dotfiles repository to ${CONTAINER_MOUNTED_HOME_PATH}/code/dotfiles..."
gh repo clone $GITHUB_USERNAME/dotfiles $CONTAINER_MOUNTED_HOME_PATH/code/dotfiles

# Copy the post-install script into the container:
echo "Copying post-install script into container's home directory..."
cp ./post-install.sh $CONTAINER_MOUNTED_HOME_PATH/

# Open a zsh terminal inside the container
echo "Running post-install script inside container..."
docker exec -ti -uwagon lewagon zsh -c "cd /home/wagon && zsh post-install.sh"

# Next, run `post-install.sh` in the terminal you just opened.

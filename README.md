# Docker Image for Le Wagon Bootcamp
## Note
- I built this project to allow me to teach and support Le Wagon's web development bootcamp.
- It gives me the flexibility of having an Ubuntu environment matching the requirements for the Windows/WSL environment as expressed in the bootcamp's setup documents.
- But it allows me to isolate this environment on my machine, and not to need to have my machine running Ubuntu (or a derivative) natively. Also, I can rebuild the image as needed to upgrade the OS, and I can shut it down and remove it as needed.
- I've tested it on both Ubuntu- and Arch-based Linux environments, but not on Windows or OS-X.

## Preparation
- To prepare, you will need to have installed Docker and Docker Compose, and be able to run `docker` and `docker-compose` as a non-root user.
- I do not recommend configuring Docker for rootless use, as this seemed to cause me issues.
- Rather, I suggest simply adding your user to the `docker` group, as specified in the post-install instructions for Docker.
- You will also need to have forked Le Wagon's `dotfiles` repository in your GitHub account.
- You should also have Git and GitHub access set up on your machine as you would for regular development, including your SSH key and GitHub's `gh` command-line app.

## Configure
1. Copy the sample environment-variable file to a new file named `.env`:
    ```bash
    cp sample-env .env
    ```
2. Fill in values for all variables in your `.env` file. For `USER`, give your Linux user name.

## Install
1. Run the installation script:
    ```bash
    bash install.sh -g <your GitHub user name> -p <location of mounted HOME directory on the host>
    ```
    This script will ask for your password (for a `sudo` command). It will create and start a new Docker container for your Le Wagon development environment.

    The script needs two arguments: your GitHub user name (to clone your `dotfiles` repository) and the location on your host computer where you want to mount the home directory of the Docker container's `wagon` user.

2. After cloning your `dotfiles` repository, the script will enter the running Docker container and run a post-install script.

    This script will run your `dotfiles` installer (but not the Git setup script!), and install Oh My Zsh, Ruby with gems, Node, and Yarn inside your new Docker container.

3. If the above steps complete without error, you should have a working Ubuntu environment capable of building and running Ruby and Rails apps for the Le Wagon bootcamp.

## Daily running
- You should be able to run `ruby`, `rake`, and `rails` commands as needed for your daily development needs.
- Graphical programs like VS Code cannot be run from inside the container. You will need to first open a terminal in the Docker host to the mounted home directory of your container. Then, change to the directory of the files you need to work on. Run `code` to open VS Code in the directory. Since this directory is mounted from your Docker container, all changes you make will apply to the running Docker container automatically, too. 

## A note about Git
- Currently, the script leaves out any Git setup. The assumption is that you will setup your Git access (including `gh`, SSH keys, etc.) on your Docker host machine, and that you will do any Git-related steps there, and not inside the Docker container. This may change in future versions.
# Docker Image for Le Wagon Bootcamp
## Note
- I built this project to allow me to teach and support [Le Wagon](https://www.lewagon.com/)'s web development bootcamp.
- It gives me the flexibility of having an Ubuntu environment matching the requirements for the Windows/WSL environment as expressed in the bootcamp's [setup documents](https://github.com/lewagon/setup).
- But it allows me to isolate this environment on my machine, and not to need to have my machine running Ubuntu (or a derivative) natively. Also, I can rebuild the image as needed to upgrade the OS, and I can shut it down and remove it as needed.
- I've tested it on both Ubuntu- and Arch-based Linux environments, but not on Windows or OS-X.

## Preparation
- To prepare, you will need to have installed [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/), and be able to run `docker` and `docker-compose` as a non-root user.
- I do not recommend configuring Docker for rootless use, as this seemed to cause me issues.
- Rather, I suggest simply adding your user to the `docker` group, as specified in the [post-install instructions](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) for Docker.
- You will also need to have forked [Le Wagon's `dotfiles` repository](https://github.com/lewagon/dotfiles) in your GitHub account.
- You should also have Git and GitHub access set up on your machine as you would for regular development, including your SSH key.
- You will need to have installed GitHub's [`gh` command-line app](https://cli.github.com/) and [logged in](https://cli.github.com/manual/gh_auth_login) to it.

## Configure
1. Copy the sample environment-variable file to a new file named `.env`:
    ```bash
    cp sample-env .env
    ```
2. Fill in values for all variables in your `.env` file. For `USER`, give your Linux user name.

## Install
### 1. Run the installation script:
```bash
bash install.sh -g <your GitHub user name> -p <location of mounted HOME directory on the host>
```

- This script will ask for your password (for a `sudo` command). It will create and start a new Docker container for your Le Wagon development environment.
- The script needs two arguments: your GitHub user name (to clone your `dotfiles` repository) and the location on your host computer where you want to [mount](https://docs.docker.com/storage/bind-mounts/) the home directory of the Docker container's default user, named `wagon`.
- The script will **create** a new Docker container for you, and **start it** up. The user will be named `wagon`, with its home directory at `/home/wagon/`.
- The script will clone your `dotfiles` repository from your own GitHub account into `/home/wagon/code/` in the container. Then it will enter the running container and run a post-install script there.

### The post-install script
- The post-install script will run the two installation scripts in your newly-cloned `dotfiles` repository: `install.sh` and `git_setup.sh`.
- It will also install [Oh My Zsh](https://ohmyz.sh/), Ruby with relevant gems, Node, and Yarn inside your new Docker container - all according to the (current) specifications in Le Wagon's setup instructions.
- It will also log you in to GitHub for the `gh` tool using a **token**. You will need to follow the instructions to open GitHub, create a token, and paste its code into the terminal window when prompted. Choose to use an existing SSH key (don't create a new one), and to paste a token (don't select to open a browser).
- Le Wagon's Git setup script will ask for your **name** and your **email address**. It will save these in the global Git configuration for the container, and they will be used when you create new Git commits.

### Installation complete
- If the above steps complete without error, you should have a working Ubuntu environment capable of building and running Ruby and Rails apps for the Le Wagon bootcamp. You should also have a second container holding a PostgreSQL database instance, which the first container can easily connect to.

## Update to latest image
- You should only run the installation script once.
- To update your Docker image to the latest released version, run the following:

```bash
docker-compose pull && docker-compose up -d
```

- Please note that the code files and anything else in your container's home directory (`/home/wagon/`) **will not be affected** when you stop, update, or even remove the Docker container. This is thanks to the home directory being [mounted](https://docs.docker.com/storage/bind-mounts/) to a location in your host computer's file system.

## Daily running
### Start the container
- You may have to restart the Ubuntu container when your computer restarts or if Docker or your container should ever crash. The separate PostgreSQL container may not restart when your computer starts up. In all cases, the following command will start both the Ubuntu container and the PostgreSQL container.
```bash
docker-compose up -d
```
- (You could create a `systemd` service to automatically restart the process, if you like)


### Open a command line in the container
- To enter the container and open a command line as the default user (`wagon`), run `./lewagon` from this directory.
- You might want to add a symlink to the `PATH` on your Docker host, to allow you to easily jump into the container whenever you need to. For example, the following will allow you to type `lwc` (for 'Le Wagon container') from anywhere on your host computer, and open a command line in the container:

```bash
ln -s <path to the lw-docker directory>/lewagon ~/.local/bin/lwc
```

### Root access
- There is no `sudo` access properly set up in the container for the moment. To enter the container as `root`, run `./lewagon-root` from this directory.

- Be sure to `exit` once you have finished your administrative task. Please be aware that any changes you make to the system, eg. installing new packages via `apt`, **will not be preserved** if you reinstall the image or update it.

### Regular commands
- You should be able to run `ruby`, `rake`, `rubocop`, `rails`, and similar commands inside your container as needed for your daily development needs.
- **Graphical programs** like VS Code cannot be run from inside the container. You will need to first open a terminal in the Docker host to the mounted home directory of your container. Then, change to the directory of the files you need to work on. Run `code .` to open VS Code in the current directory. Since this directory is mounted from your Docker container, all changes you make will apply to the running Docker container automatically, too. 

## A note about Git
- You should supply the path to your SSH key in the `.env` file before running the install script. This will mount your SSH key read-only into the `wagon` user's home directory in the container. 
- When you first enter the container, you will be prompted for your SSH passphrase. If you add `ssh-agent` as one of the Oh My Zsh plugins in your `~/.zshrc` file, you should only be prompted once per session for your passphrase.
- All being well, you should be able to perform any Git operations you might need.

## A note about Rails
- Rails looks for the Postgres database on a Unix socket by default. This won't work for a containerized solution as provided here.
- Instead, the Postgres database is running in its own container, using the networking ports of the host machine. This means that you can access it as if it were listening on `localhost`.
- This requires a small change to the Rails setup templates provided by Le Wagon: you need to specify `port: localhost`.
- To this end, I have forked the relevant repository and made this change. To use it, run your `rails new` command like so:

```bash
# Using the Minimal template:
rails new \        
  --database postgresql \
  --webpack \
  -m https://raw.githubusercontent.com/bluepostit/rails-templates/docker/minimal.rb \
  test-app

# Using the Devise template:
rails new \       
  --database postgresql \
  --webpack \
  -m https://raw.githubusercontent.com/bluepostit/rails-templates/docker/devise.rb \
  test-devise-app
```

---

## Build Docker image
- This step is not needed to get a running container. I've included it as a quick reference for myself.
- You need to be authenticated for Docker.
- The commands below assume you are authenticated for the given account.

```bash
# Build the image
docker build . --no-cache -t runfire9/lw-bootcamp:latest

# Push it to dockerhub
docker push runfire9/lw-bootcamp:latest
```

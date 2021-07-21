#!/bin/bash

# Don't run this script first!
# Please run install.sh on your Docker host.
# It will copy this script to your Docker container, and run it there.

install_dotfiles()
{
  mkdir -p ~/code

  # Install dotfiles (which have already been cloned)
  cd ~/code/dotfiles
  zsh install.sh
}

setup_git_and_github()
{
  # Run the Git setup script inside dotfiles
  cd ~/code/dotfiles
  zsh git_setup.sh

  # Log in to gh (GitHub's command-line tool)
  gh auth login -s 'user:email'
}

install_everything()
{
  install_dotfiles
  setup_git_and_github
}

# Default: install everything.
install_everything

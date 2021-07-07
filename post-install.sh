#!/bin/bash

# Don't run this script first!
# Please run install.sh on your Docker host.
# It will copy this script to your Docker container, and run it there.

RUBY_VERSION="2.7.3"
RAILS_VERSION="6.0"
NODE_VERSION="14.15.5"

# Install Oh My Zsh
install_oh_my_zsh()
{
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

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

# Install rbenv
install_rbenv()
{
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
}

# Install Ruby
install_ruby_and_gems()
{
  ~/.rbenv/bin/rbenv install ${RUBY_VERSION} && ~/.rbenv/bin/rbenv global ${RUBY_VERSION}

  # Install gems
  ~/.rbenv/shims/gem install \
    rake \
    bundler \
    rspec \
    rubocop \
    rubocop-performance \
    pry \
    pry-byebug \
    colored \
    http \
    nokogiri \
    rails:${RAILS_VERSION}
}

# Install nvm, node, and yarn
install_nvm_and_node()
{
  NVM_DIR=/home/$USER/.nvm
  NVM_INSTALL_PATH=$NVM_DIR/versions/node/v$NODE_VERSION

  curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh
  zsh -c " \
    source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION"
}

install_yarn()
{
  NVM_DIR=/home/$USER/.nvm
  NVM_INSTALL_PATH=$NVM_DIR/versions/node/v$NODE_VERSION

  NODE_PATH=${NVM_INSTALL_PATH}/lib/node_modules
  PATH=${NVM_INSTALL_PATH}/bin:$PATH

  npm install --global yarn
}

install_everything()
{
  install_oh_my_zsh
  install_dotfiles
  setup_git_and_github
  install_rbenv
  install_ruby_and_gems
  install_nvm_and_node
  install_yarn
}

install_latest_ruby_and_gems()
{
  install_ruby_and_gems
}

# Default: install everything.
install_everything

# Only install Ruby and relevant gems:
# install_latest_ruby_and_gems
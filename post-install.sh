#!/bin/bash

# Don't run this script first!
# Please run install.sh on your Docker host.
# It will copy this script to your Docker container, and run it there.

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


mkdir -p ~/code

# Install dotfiles (which have already been cloned)
cd ~/code/dotfiles
zsh install.sh

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby
~/.rbenv/bin/rbenv install 2.6.6 && ~/.rbenv/bin/rbenv global 2.6.6

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
  rails:6.0

# Install nvm, node, and yarn
NVM_DIR=/home/$USER/.nvm
NODE_VERSION=14.15.0
NVM_INSTALL_PATH=$NVM_DIR/versions/node/v$NODE_VERSION

curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh
zsh -c " \
  source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION"

NODE_PATH=${NVM_INSTALL_PATH}/lib/node_modules
PATH=${NVM_INSTALL_PATH}/bin:$PATH

npm install --global yarn

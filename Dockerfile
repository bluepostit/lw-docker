FROM ubuntu:groovy

ENV USER wagon
ARG UID=1000

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt update && apt install -y curl gpg locales && \
  echo 'debconf debconf/frontend select noninteractive' | debconf-set-selections && \
  # Repository for gh
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  # Locale setup
  sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen && \
  \
  # Install git, zsh, postgresql, libraries for Ruby, etc.
  apt update && apt install -y \
  locales git apt-transport-https apt-utils unzip zsh curl vim \
  imagemagick jq build-essential software-properties-common sudo \
  tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev \
  libreadline-dev postgresql-client postgresql-common postgresql-contrib gh && \
  apt clean && \
  \
  # Create user
  useradd --create-home --shell /usr/bin/zsh --uid "$UID" $USER && \
  chown -R $USER /home/${USER}

COPY ./post-install.sh /opt/

# RUN mv /bin/sh /bin/sh-old && ln -s /bin/bash /bin/sh

# USER $USER
# WORKDIR /home/$USER

# # Install Oh My Zsh
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# RUN /bin/bash -c "zsh --version"

# # Install Node with nvm
# ENV NVM_DIR /home/$USER/.nvm
# ENV NODE_VERSION 14.15.0
# ENV NVM_INSTALL_PATH $NVM_DIR/versions/node/v$NODE_VERSION

# USER $USER
# RUN mkdir -p ${NVM_DIR} && \
#   curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# RUN /bin/bash -c " \
#   source $NVM_DIR/nvm.sh \
#   && nvm install $NODE_VERSION"

# ENV NODE_PATH ${NVM_INSTALL_PATH}/lib/node_modules
# ENV PATH ${NVM_INSTALL_PATH}/bin:$PATH

# RUN npm install --global yarn

# # Install Ruby with rbenv
# RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# RUN ~/.rbenv/bin/rbenv install 2.6.6 && ~/.rbenv/bin/rbenv global 2.6.6

# # Install gems
# RUN ~/.rbenv/shims/gem install \
#   rake \
#   bundler \
#   rspec \
#   rubocop \
#   rubocop-performance \
#   pry \
#   pry-byebug \
#   colored \
#   http \
#   nokogiri \
#   rails:6.0


# TO DO after container creation:
# - gh auth login -s 'user:email' -w
# (fork and) clone the dotfiles repo

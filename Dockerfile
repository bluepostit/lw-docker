FROM ubuntu:groovy

ENV USER wagon
ENV UID "$UID"
ENV GID "$GID"

# Setup Timezone env variable
ENV TZ Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install git, zsh, postgresql, libraries for Ruby, etc.
RUN apt update && \
  apt install -y git apt-transport-https apt-utils unzip zsh curl vim \
  imagemagick jq build-essential software-properties-common sudo \
  tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev \
  libreadline-dev && \
  apt clean

# Install gh
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0
RUN add-apt-repository https://cli.github.com/packages && apt update && apt install -y gh

# Create user
RUN useradd --create-home --shell /usr/bin/zsh --uid ${UID} --gid ${GID} $USER

# RUN mv /bin/sh /bin/sh-old && ln -s /bin/bash /bin/sh

USER $USER
WORKDIR /home/$USER

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN /bin/bash -c "zsh --version"

# Install Node with nvm
ENV NVM_DIR /home/$USER/.nvm
ENV NODE_VERSION 14.15.0
ENV NVM_INSTALL_PATH $NVM_DIR/versions/node/v$NODE_VERSION

USER $USER
RUN mkdir -p ${NVM_DIR} && \
  curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
RUN /bin/bash -c " \
  source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION"

ENV NODE_PATH ${NVM_INSTALL_PATH}/lib/node_modules
ENV PATH ${NVM_INSTALL_PATH}/bin:$PATH

RUN npm install --global yarn

# Install Ruby with rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install 2.6.6 && ~/.rbenv/bin/rbenv global 2.6.6

# Install gems
RUN ~/.rbenv/shims/gem install \
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


# TO DO:
# - gh auth login -s 'user:email' -w
# (fork and) clone the dotfiles repo
# create role for postgres user in DB

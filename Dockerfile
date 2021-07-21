FROM ubuntu:groovy

ARG RUBY_VERSION=2.7.3
ARG RAILS_VERSION=6.0
# This is named differently to avoid triggering an automatic
# installation of Node by nvm.
ARG NODE_VERSION_STRING=14.15.5

ARG USER=wagon
ARG UID=1000
ENV HOME=/home/${USER}

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y curl gpg locales && \
  echo 'debconf debconf/frontend select noninteractive' | debconf-set-selections && \
  \
  # Add repository for gh
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  \
  # Locale setup
  rm -rf /var/lib/apt/lists/* && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  locale-gen en_US.UTF-8 && \
  \
  # Install git, zsh, postgresql, libraries for Ruby, etc.
  apt-get update && apt-get install -y \
  locales git apt-transport-https apt-utils unzip zsh curl vim \
  imagemagick jq build-essential software-properties-common sudo \
  tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev \
  libreadline-dev gh libsqlite3-dev \
  postgresql-client libpq-dev postgresql-common postgresql-contrib && \
  apt clean && \
  \
  # Create user
  useradd --create-home --shell /usr/bin/zsh --uid "$UID" $USER && \
  chown -R $USER /home/${USER} && \
  \
  # Install rbenv, Ruby and gems
  git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv && \
  git clone https://github.com/rbenv/ruby-build.git \
    ${HOME}/.rbenv/plugins/ruby-build && \
  PATH="${HOME}/.rbenv/bin:${PATH}" && \
  ${HOME}/.rbenv/bin/rbenv install ${RUBY_VERSION} && \
  ${HOME}/.rbenv/bin/rbenv global ${RUBY_VERSION} && \
  ${HOME}/.rbenv/shims/gem install \
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
    rails:${RAILS_VERSION} && \
  \
  # Install Oh My Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  \
  # Install nvm, node and yarn
  curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh && \
  NVM_DIR=${HOME}/.nvm && \
  NODE_VERSION=14.15.5 && \
    zsh -c "source ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION_STRING} && \
    source ${HOME}/.zshrc && \
    npm install --global yarn" && \
  echo "Done"

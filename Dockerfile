FROM ubuntu:groovy

ENV USER wagon
ARG UID=1000

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
  # sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  # locale-gen && \
  rm -rf /var/lib/apt/lists/* && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  locale-gen en_US.UTF-8 && \
  \
  # Install git, zsh, postgresql, libraries for Ruby, etc.
  apt-get update && apt-get install -y \
  locales git apt-transport-https apt-utils unzip zsh curl vim \
  imagemagick jq build-essential software-properties-common sudo \
  tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev \
  libreadline-dev postgresql-client postgresql-common postgresql-contrib gh && \
  apt clean && \
  \
  # Create user
  useradd --create-home --shell /usr/bin/zsh --uid "$UID" $USER && \
  chown -R $USER /home/${USER}

# COPY ./post-install.sh /opt/

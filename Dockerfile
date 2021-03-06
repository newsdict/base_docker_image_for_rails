# define ubuntu version, you can use --build-arg
ARG ubuntu_version="19.10"
FROM ubuntu:${ubuntu_version}
# Dockerfile on bash
SHELL ["/bin/bash", "-c"]
# Default nvm version, you can use --build-arg
ARG nvm_version="0.35.2"
# Default node version, you can use --build-arg
ARG node_version="v13.9.0"
# Default ruby version, you can use --build-arg
ARG ruby_version="2.7.0"
# Default ffi version, you can use --build-arg
ARG ffi_version="1.12.2"
# Default sassc version, you can use --build-arg
ARG sassc_version="2.2.1"
# Install packages
RUN apt update && apt install --no-install-recommends  -y gnupg2 gnupg1 gnupg libmagickwand-dev libmecab-dev libxslt-dev mecab-ipadic mecab-ipadic-utf8 mecab-utils openjdk-8-jdk graphicsmagick graphviz nginx python2 git curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && apt update && apt install --no-install-recommends -y yarn
# Installv nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh | bash
ENV NVM_DIR "/root/.nvm"
RUN . ${NVM_DIR}/nvm.sh && nvm install ${node_version} && nvm alias default 
# Install rvm and ruby
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && curl -sSL https://get.rvm.io | bash -s stable && . /etc/profile.d/rvm.sh && rvm install ${ruby_version} && gem install bundler
# Install sassc. For fast install of gem.
RUN echo "gem: --no-rdoc --no-ri" > ~/.gemrc
RUN . /etc/profile.d/rvm.sh && gem install "sassc:${sassc_version}" "ffi:${ffi_version}"

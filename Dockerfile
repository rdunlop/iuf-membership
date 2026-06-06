FROM ruby:3.2.10

# Install NodeJS based on https://github.com/nodesource/distributions#installation-instructions
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_24.x | bash # Installs the node repository
RUN apt-get install --yes nodejs # Actually install NODEJS

# Install Yarn
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/yarn.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -yqq && apt-get install -y yarn
RUN gem install bundler -v 2.5.23 # install newer bundler version

RUN mkdir /app

WORKDIR /app
ENV BUNDLE_PATH /gems

ENTRYPOINT ["./docker-entrypoint.sh"]

FROM ruby:2.2.5-slim

MAINTAINER Charles Gilliam <gilliamcc@gmail.com>

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
        build-essential \
        libxml2-dev libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /archivist-api

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle install --binstubs

COPY . .

RUN bundle exec rake assets:precompile

CMD puma -C config/puma.rb

FROM ruby:2.2.5-slim

MAINTAINER Charles Gilliam <gilliamcc@gmail.com>

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
        build-essential \
        libxml2-dev libxslt1-dev \
        poppler-utils \
    && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /archivist-api

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle install --binstubs

COPY . .

CMD puma -C config/puma.rb

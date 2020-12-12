FROM ubuntu:18.04

RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && apt-get install -y build-base

RUN gem install bundler -v 2.1.4

COPY . ./

RUN bundle config path ./vendor/bundle
RUN bundle install

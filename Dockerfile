FROM ruby:2.6.5

RUN mkdir -p /app
WORKDIR /app

RUN gem install bundler -v 2.1.4

COPY . ./

RUN bundle config path vendor/bundle
RUN bundle install

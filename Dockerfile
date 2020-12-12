FROM ruby:2.6.3-alpine AS builder

RUN mkdir -p /app
WORKDIR /app

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  sqlite-dev \
  sqlite-libs \
  sqlite \
  tzdata \
  yarn

RUN gem install bundler -v 2.1.4
RUN gem install rake -v 13.0.1

COPY Gemfile Gemfile.lock /app
RUN bundle config set without development test
RUN bundle install

COPY package.json yarn.lock /app
RUN yarn install

FROM builder AS test

RUN mkdir -p /app
WORKDIR /app

RUN bundle config unset without
RUN bundle config set with test

RUN bundle install

COPY . ./
RUN RAILS_ENV="test"

CMD ["bundle", "exec", "rails", "test"]

FROM ruby:2.6.3-alpine

RUN mkdir -p /app
WORKDIR /app

RUN apk add --update \
  tzdata \
  sqlite-libs \
  sqlite

COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY . ./

RUN RAILS_ENV="production"

CMD ["bundle", "exec", "puma"]
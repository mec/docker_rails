FROM ruby:2.6.5 AS dependancies

RUN mkdir -p /app
WORKDIR /app

RUN gem install bundler -v 2.1.4

COPY . ./

RUN bundle config path vendor/bundle
RUN bundle config deployment true
RUN bundle install

FROM ruby:2.6.5

RUN mkdir -p /app
WORKDIR /app

RUN gem install bundler -v 2.1.4

COPY --from=dependancies /app/vendor/bundle ./vendor/bundle
COPY Gemfile Gemfile.lock ./

RUN bundle config path vendor/bundle
RUN bundle config deployment true
RUN bundle install


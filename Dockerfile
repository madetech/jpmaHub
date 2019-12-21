FROM ruby:2.6.5-alpine3.10

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN apk --no-cache add alpine-sdk postgresql-dev postgresql-libs postgresql-client less && bundle install && apk del alpine-sdk

COPY . /app
EXPOSE 9292

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]
### === base === ###
FROM ruby:2.7.3-alpine3.13 AS base
RUN apk add --no-cache --update postgresql-dev tzdata nodejs

ENV BUNDLE_PATH=/app/vendor/bundle
RUN gem install bundler && bundle config path $BUNDLE_PATH
RUN mkdir -p /app
WORKDIR /app

### === development === ###
FROM base AS development
RUN apk add --update build-base \
  linux-headers \
  git \
  yarn \
  less \
  curl \
  gnupg \
  python3

RUN gem install solargraph

ARG UID=1001
ARG GID=1001
RUN addgroup -S app -g $GID && adduser -S -u $UID -G app -D app && chown -R $UID:$GID /app || true
USER $UID

RUN bundle config cache true

### === build === ###                                                                                                                                 [0/
FROM development AS build

ENV RAILS_ENV=production
ENV NODE_ENV=production

COPY --chown=app . /app

RUN bundle config without test:development && bundle config cache true \
 bundle install && bundle cache
RUN yarn install

RUN bin/webpack
RUN rm -rf /app/node_modules/*

### === production === ###
FROM base AS production

RUN mkdir -p /app && adduser -D app && chown -R app /app
WORKDIR /app

RUN bundle config deployment true && bundle config --without development test

COPY --chown=app --from=build /app /app
USER app
RUN bundle install --without development test
RUN bundle clean
RUN bundle package

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_LOG_TO_STDOUT="true"
ENV PORT=3000
EXPOSE $PORT
CMD ["bin/rails", "s", "-b", "0.0.0.0"]

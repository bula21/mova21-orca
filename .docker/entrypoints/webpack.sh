#!/bin/sh
set -e

bundle check || exit 1
yarn check --silent || exit 1

#bundle exec rails webpacker:compile

exec "$@"

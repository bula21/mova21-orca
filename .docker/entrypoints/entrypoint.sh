#!/usr/bin/env sh
set -e

# Drop privileges
su-exec app "$@"

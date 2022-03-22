#!/usr/bin/env sh
set -e

# For explanation why this is needed:
# https://docs.microsoft.com/en-us/azure/app-service/configure-linux-open-ssh-session#use-ssh-support-with-custom-docker-images

# To allow Azure SSH shell
export > /root/.profile
/usr/sbin/sshd

su-exec app "$@"

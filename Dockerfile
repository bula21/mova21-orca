### === base === ###                 
FROM ruby:3.1.2-alpine AS base
RUN apk add --no-cache --update postgresql-dev tzdata nodejs
RUN adduser -D develop
RUN gem install bundler
# ENV PYTHON=/usr/bin/python3

### === development === ###                 
FROM base AS development
RUN apk add --update build-base \
    libffi \
    python3 \
    linux-headers \
    git \
    yarn \
    gcompat \
    less \
    curl \
    gnupg \
    openssh-client

RUN gem install solargraph standardrb ruby-debug-ide debug rufo

ENV BUNDLE_CACHE_ALL=true
ENV BUNDLE_PATH=/home/develop/app/vendor/bundle
USER develop
RUN mkdir -p /home/develop/app
WORKDIR /home/develop/app

### === build === ### 
FROM development AS build

ENV RAILS_ENV=production

COPY --chown=develop . /home/develop/app
RUN mkdir -p /home/develop/app/vendor/cache && \
    mkdir -p /home/develop/app/vendor/bundle && \
    mkdir -p /home/develop/app/node_modules

RUN bundle install && \
    bundle clean && \
    bundle package

RUN yarn install && \
    NODE_ENV=production bin/webpacker

### === production === ###
FROM base AS production

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
 # See here for details: https://docs.microsoft.com/en-us/azure/app-service/configure-linux-open-ssh-session#use-ssh-support-with-custom-docker-images
 RUN apk add --no-cache openssh su-exec \
   && echo "root:Docker!" | chpasswd 

 # Copy the sshd_config file to the /etc/ssh/ directory
 COPY .docker/sshd_config /etc/ssh/
 COPY .docker/entrypoints/azure-entrypoint.sh /azure-entrypoint

 # Copy and configure the ssh_setup file
 RUN mkdir -p /tmp
 COPY .docker/ssh_setup.sh /tmp
 RUN chmod +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

RUN adduser -D app && mkdir -p /app && chown -R app /app
USER app    
WORKDIR /app

ENV BUNDLE_WITHOUT="test:development"
ENV BUNDLE_DEPLOYMENT="true"
ENV BUNDLE_PATH=/app/vendor/bundle
ENV RAILS_ENV=production               
ENV NODE_ENV=production 
ENV RAILS_LOG_TO_STDOUT="true"  
ENV PORT=3000

COPY --chown=app --from=build /home/develop/app /app                              
RUN bundle install --local
RUN rm -rf /app/node_modules/* 

USER root
EXPOSE $PORT 2222
ENTRYPOINT ["/azure-entrypoint"]
CMD [".docker/entrypoints/app.sh", "bin/rails", "s", "-b", "0.0.0.0"] 

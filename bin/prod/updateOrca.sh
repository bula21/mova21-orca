#!/usr/bin/env bash
cd /container/mova21-orca
git pull
docker-compose -f docker-compose.production.yml build --pull
#docker-compose down
#docker-compose -f docker-compose.production.yml run --rm app bin/rails db:migrate
#docker-compose up -d

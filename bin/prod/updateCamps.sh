#!/usr/bin/env bash
cd /container/mova21-orca
/usr/local/bin/docker-compose -f docker-compose.production.yml run --rm app bin/rails r 'PullAllCampUnitsJob.perform_now'

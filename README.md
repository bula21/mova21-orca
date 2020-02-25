# orca
Orca manages people and  activity subscriptions.

## Development

```
docker-compose up app
```

If you want to run speci

## Setup Auth

### Developer Stategy



ENVs that have to be set:

-

## Setup Midata

ENVs that have to be set:

- MIDATA_BASE_URL: The base-url of the hitobito instance to connect to
- MIDATA_USER_EMAIL: The email of the user to connect as
- MIDATA_USER_TOKEN: The token of the user to connect as (not the password). Refer to https://github.com/hitobito/hitobito/blob/master/doc/development/05_rest_api.md
- ROOT_CAMP_UNIT_ID_WOLF: The ID of the root Wolfstufen-Lager
- ROOT_CAMP_UNIT_ID_PFADI: The ID of the root Pfadistufen-Lager
- ROOT_CAMP_UNIT_ID_PIO: The ID of the root Piostufen-Lager
- ROOT_CAMP_UNIT_ID_PTA: The ID of the root Pta-Lager

Fetch CampUnits from MiData, e.g. for :pfadi
```
bin/rails r Unit::ROOT_CAMP_UNITS[:pfadi].camp_unit_builder.pull_camp_unit_hierarchy
```

## Tests

```
docker-compose run --use-aliases test
```

or run a shell in the test env and run tests from within

```
docker-compose run --use-aliases test sh
bin/check
```

## Production

Build

```
docker-compose -f docker-compose.production.yml build production
```

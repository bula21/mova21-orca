# orca
Orca manages people and  activity subscriptions.

## Development

```
docker-compose up app
```

## Tests

```
docker-compose run test
```

## Tasks

Fetch CampUnits from MiData
```
bin/rails r Unit::ROOT_CAMP_UNITS[:pfadi].camp_unit_builder.pull_camp_unit_hierarchy
```

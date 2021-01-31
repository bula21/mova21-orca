# orca

Orca manages people and activity subscriptions.

## Development

```
docker-compose up app
```

or open with VS Code Dev Container Extension

## Setup Auth

## Roles

- User (`role_user`)
- Admin (`role_admin`)
- Programm (`role_programm`)

```
# Give a user admin role
user.role_admin = true
user.save

# or
user.update(role_admin: true)

# to remove a role
user.update(role_programm: false)
```

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

```
# Fetch new CampUnits from MiData
bin/rails r "PullNewCampUnitsJob.perform_now"

# Fetch all CampUnits from MiData
bin/rails r "PullAllCampUnitsJob.perform_now"
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

### STORAGE

We use ActiveStorage to store files. To set it up in production use these ENV-Variables:

- STORAGE_SERVICE=azure
- STORAGE_ACCOUNT_NAME=
- STORAGE_ACCESS_KEY=
- STORAGE_CONTAINER=

## Tasks

### Export Invoices

```ruby
puts InvoiceExporter.new.export
```

```bash
docker-compose run bin/rails r 'puts InvoiceExporter.new.export; STDOUT.flush' > tmp/export.csv
```

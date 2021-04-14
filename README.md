# orca

Orca manages people and activity subscriptions.

## Development

```
docker-compose up
```

or open with VS Code Dev Container Extension

If you have started a container, and you want the functionality of a bash:

```
docker-compose exec app ash
```

## Setup Auth

## Roles

- User (`role_user`)
- Admin (`role_admin`)
- Programm (`role_programm`)
  - Activity, Tag, Category
- TN Administration (`role_tn_administration`)
  - Unit, Participant, Leader
- Editor (`role_editor`)
  - Activity

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
docker-compose run app bin/rspec
```

or much faster (if you already have started a container)

```
docker-compose exec app bin/rspec
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

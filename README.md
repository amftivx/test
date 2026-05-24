# Items API

A minimal Sinatra REST API with full CRUD for a mock `Item` resource. In-memory storage, no database required.

## Requirements

- Ruby
- Bundler

## Setup

```bash
bundle install
```

API key is loaded from `~/.secret` at startup (`PHANTOM_KEY`).

## Run

```bash
bundle exec rackup        # port 9292
bundle exec ruby app.rb   # port 4567
```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /items | List all items |
| GET | /items/:id | Get one item |
| POST | /items | Create item |
| PUT | /items/:id | Update item |
| DELETE | /items/:id | Delete item |

### Item shape

```json
{ "id": 1, "name": "Widget", "description": "A fine widget" }
```

## Example curl commands

```bash
# List all
curl -s http://localhost:4567/items

# Create
curl -s -X POST http://localhost:4567/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"Widget","description":"A fine widget"}'

# Get one
curl -s http://localhost:4567/items/1

# Update
curl -s -X PUT http://localhost:4567/items/1 \
  -H 'Content-Type: application/json' \
  -d '{"name":"Widget Pro","description":"Upgraded"}'

# Delete
curl -s -X DELETE http://localhost:4567/items/1
```

## Tests

```bash
bundle exec rspec
```

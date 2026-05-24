# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Test driven

We use test driven development. First test, then code. No line without test.

## Commands
```bash
bundle install          # install dependencies
bundle exec rspec       # run all tests
bundle exec rspec spec/app_spec.rb:42  # run a single test by line number
bundle exec ruby app.rb # start server on port 4567
bundle exec rackup      # start server on port 9292 via config.ru
```

## Architecture

Single-file Sinatra app (`app.rb`) with three layers:

- **`ItemStore` module** — in-memory data store (array + auto-increment ID). Call `ItemStore.reset` between tests to isolate state.
- **Sinatra routes** — thin handlers that delegate to `ItemStore` and serialize to JSON. All responses set `Content-Type: application/json` via a `before` filter.
- **`config/secrets.rb`** — loaded at startup; reads `KEY=VALUE` pairs from `~/.secret` into `ENV` without overwriting existing values. `PHANTOM_KEY` is the expected secret.

Tests use `rack-test` to drive the app in-process (`RACK_ENV=test`). No HTTP server needed for tests.

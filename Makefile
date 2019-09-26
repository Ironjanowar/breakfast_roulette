MIX_ENV?=dev

SHELL := /bin/bash

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

env:
	source .env

start-db: env
	docker run --rm --name "$$PG_NAME" \
		-e POSTGRES_PASSWORD="$$PG_PASSWORD" \
		-d -p 5432:5432 \
		postgres

stop-db: env
	docker stop "$$PG_NAME"

setup-db: env
	mix ecto.create
	mix ecto.migrate

start: env
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette daemon

iex: env
	iex -S mix

clean:
	rm -rf _build

purge: clean
	rm -rf deps
	rm mix.lock

stop:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette stop

attach:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette attach

release: deps compile
	mix release

debug: env
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette console

error_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/error.log

debug_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/debug.log

.PHONY: deps compile release start clean purge env iex stop attach debug start-db stop-db setup-db

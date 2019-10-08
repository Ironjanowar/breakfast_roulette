MIX_ENV?=dev

SHELL := /bin/bash
include .env

deps:
	mix deps.get
	mix deps.compile

compile: deps
	mix compile

setup-db: pre-db start-db deps
	mix ecto.create
	mix ecto.migrate

start-db:
	docker run --rm --name "$$PG_NAME" \
		-e POSTGRES_PASSWORD="$$PG_PASSWORD" \
		-d -p "$$PGPORT:5432" \
		-v db:/var/lib/postgresql/data \
		postgres

stop-db:
	docker stop "$$PG_NAME"

pre-db:
	test -d db || mkdir db

start:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette daemon

iex:
	iex -S mix

clean:
	rm -rf _build

purge: clean
	rm -rf deps
	(test -f mix.lock && rm mix.lock) || true

purge-db:
	rm -rf db


stop:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette stop

attach:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette attach

release: deps compile
	mix release

debug:
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette console

error_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/error.log

debug_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/debug.log

.PHONY: deps compile release start clean purge iex stop attach debug start-db stop-db setup-db

MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

token:
export BOT_TOKEN = $(shell cat bot.token)

start: token
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette daemon

iex: token
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

debug: token
	_build/dev/rel/breakfast_roulette/bin/breakfast_roulette console

error_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/error.log

debug_logs:
	tail -n 20 -f _build/dev/rel/breakfast_roulette/log/debug.log

.PHONY: deps compile release start clean purge token iex stop attach debug

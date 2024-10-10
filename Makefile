default: start
compile:
	mix do deps.get, deps.compile, compile
start:
	DISPLAY=:0 iex -S mix
release:
	rm -rf ~/kiosk
	MIX_ENV=prod mix deps.get --only prod
	MIX_ENV=prod mix release --path ~/kiosk

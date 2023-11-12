fmt:
	stylua lua/ --config-path .stylua.toml

lint:
	luacheck lua/ --globals vim


pr-ready: fmt lint

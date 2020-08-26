PREFIX ?= /usr/local
BIN_PATH = $(PREFIX)/bin
BUILD_PATH = .build/release

setup_keys:
	sed -i '' "s/key: \"<CONSUMER_KEY>\",/key: \"$(CONSUMER_KEY)\",/g" Sources/RehatchCLI/Secrets.swift
	sed -i '' "s/secret: \"<CONSUMER_SECRET>\"/secret: \"$(CONSUMER_SECRET)\"/g" Sources/RehatchCLI/Secrets.swift

build: setup_keys
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(BIN_PATH)
	install $(BUILD_PATH)/rehatch $(BIN_PATH)

uninstall:
	rm -rf $(BIN_PATH)/rehatch

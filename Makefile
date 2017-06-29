
BUILD_DIR=build

.PHONY: build

build:
	truffle compile

migrate:
	trufle migrate

test: test/*.js
	truffle test

clean:
	rm -rf ${BUILD_DIR}

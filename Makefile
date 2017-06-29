
SOL_DIR=./contracts
BUILD_DIR=builds

.PHONY: build

build:
	truffle compile

migrate:
	trufle migrate

test: test/*.js
	truffle test

clean:
	rm -rf ${BUILD_DIR}

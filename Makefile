
SOL_DIR=./contracts
BUILD_DIR=builds

*.sol: 
	solc --bin --abi -o ${BUILD_DIR} --overwrite ${SOL_DIR}/*.sol

test:
	npm test

clean:
	rm -rf ${BUILD_DIR}

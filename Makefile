
SOL_DIR=./solidity/contracts
BUILD_DIR=builds

*.sol: 
	solc --bin --abi -o ${BUILD_DIR} --overwrite ${SOL_DIR}/*.sol

clean:
	rm -rf ${BUILD_DIR}


SOL_DIR=./solidity/contracts

*.sol: 
	solc --bin --abi -o builds --overwrite ${SOL_DIR}/*.sol

pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Token.sol";

contract TestToken {

    function testDeployToken() {
        uint256 supply = 100000000; // 100m
        Token token = new Token('Farad', 'FRD', 8, supply);

        // get balance,
        Assert.equal(token.balanceOf(msg.sender), supply, 'Balance should be 100m');
    }
}

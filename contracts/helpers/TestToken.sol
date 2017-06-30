pragma solidity ^0.4.11;

import 'truffle/Assert.sol';
import 'truffle/DeployedAddresses.sol';
import '../Token.sol';

/**
 * TestToken is a derived contract from Token that adds the
 * totalSupply parameter to the derived token, as Token is
 * implemented as pure ERC20 token.
 *
 */
contract TestToken is Token {

    TestToken(string _name, string _symbol, uint8 _decimals, uint256 _supply)
        Token(_name, _symbol, _decimals) 
    {
        totalSupply = _supply;
        balance[msg.sender] = _supply;
    } 
}

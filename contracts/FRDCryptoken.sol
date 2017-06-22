
pragma solidity ^0.4.11;

import './Token.sol';

contract FRDCryptoken is Token {

    string public name = 'FRD';             // the token name
    string public symbol = 'ƒ';             // the token symbol
    uint8 public decimals = 8;              // the number of decimals

    // our constructor
    function FRDCryptoken(uint256 _totalSupply)
        Token(name, symbol, decimals, _totalSupply) 
    {
    }

}


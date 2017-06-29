
pragma solidity ^0.4.11;

import './Token.sol';

contract FRDCryptoken is Token {

    string public name = 'FARAD';             // the token name
    string public symbol = 'FRD';             // the token symbol
    uint8 public decimals = 8;              // the number of decimals

    // our constructor, just supply the total supply.
    function FRDCryptoken(
        uint256 _totalSupply
    ) Token(name, symbol, decimals, _totalSupply) {
    }

}

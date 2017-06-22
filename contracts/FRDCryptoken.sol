
pragma solidity ^0.4.11;

import './Token.sol';
import './PreICO.sol';

contract FRDCryptoken is Token {

    uint256 escrowAccountBalance = 0;

    PreICO preICO;

    // our constructor
    function FRDCryptoken(
        string _name, 
        string _symbol,
        uint8 _decimals,
        uint256 _totalSupply,
        uint256 _preICOSupply,
        address _preICOBeneficiary)
        Token(_name, _symbol, _decimals, _totalSupply) {
        require(bytes(_symbol).length == 3);

        // initialize our ICOs
        var begin = now;
        preICO = new PreICO(begin, begin + 48*60*60*1000, _preICOSupply, _preICOBeneficiary);
    }

}


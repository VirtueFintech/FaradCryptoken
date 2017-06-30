pragma solidity ^0.4.11;

import './ERC20Token.sol';

/**
 * FRDCryptoken is the main contract that will be published, including the
 * manufacturing paramters that need to be pushed/published to the blockchain
 * for traceability in the manufaturing process, as well as real-time updates
 * on the escrow balance whenever the cryptoyalty is paid from the manufacturer.
 *
 */
contract FRDCryptoken is ERC20Token {

    string public name = 'FARAD';       // the token name
    string public symbol = 'FRD';       // the token symbol
    uint8 public decimals = 12;         // the number of decimals

    // our constructor, just supply the total supply.
    function FRDCryptoken(uint256 _totalSupply) 
        ERC20Token(name, symbol, decimals) 
    {
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

}

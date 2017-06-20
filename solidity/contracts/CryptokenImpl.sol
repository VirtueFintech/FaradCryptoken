
pragma solidity ^0.4.11;

import './Cryptoken.sol';
import './CryptokenHolderImpl.sol';
import './TokenImpl.sol';

contract CryptokenImpl is Cryptoken, TokenImpl {

    uint256 escrowAccountBalance = 0;

    // published new owner of Cryptoken
    event NewCryptoken(address _owner);

    // disown Cryptoken
    event Disown(address _user, uint256 _value);

    // our constructor
    function CryptokenImpl(
        string _name, 
        string _symbol,
        uint8 _decimals)
        TokenImpl(_name, _symbol, _decimals) {
        require(bytes(_symbol).length == 3);

        // announce new owner of Cryptoken
        NewCryptoken(address(this));
    }

}



pragma solidity ^0.4.11;

import './CryptokenHolder.sol';
import './Token.sol';

contract CyptokenHolderImpl is CryptokenHolder, Token {

    function CryptokenHolderImpl() {}

    // biz rules
    modifier isNotSelf(address _address) { require(_address != address(this)); _; }
    modifier isValidAddress(address _address) { require(_address != 0x0); _; }
    modifier isValidValue(uint256 _value) { require(_value > 0); _; }

    // withdraw token amount to another address
    function withdrawTokens(Token _token, address _to, uint256 _value) 
        public
        isValidAddress(_token)
        isValidAddress(_to)
        isNotSelf(_to) 
        isValidValue(_value) {
        // send using IToken interface
        _token.transfer(_to, _value);
    }


}


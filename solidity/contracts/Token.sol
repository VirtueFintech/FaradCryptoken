
pragma solidity ^0.4.11;

contract Token {

    // Standard token definition that includes
    // name, symbol and decimals to be used.
    //
    function name() public constant returns (string name) { name; }
    function symbol() public constant returns (string symbol) { symbol; }
    function decimals() public constant returns (uint8 decimals) { decimals; }

    // the attributes of the token
    function totalSupply() public constant returns (uint256 totalSupply) { 
        totalSupply; 
    }

    // get token balance
    function balanceOf(address _owner) public constant 
            returns (uint256 balance) {
        _owner; balance;
    }

    // transfer 
    function transfer(address _to, uint256 _value) public 
        returns (bool success);

    // transfer from
    function transferFrom(address _from, address _to, uint256 _value) public
        returns (bool success);

    // approve spending
    function approve(address _spender, uint256 _value) public 
        returns (bool success);
        
}


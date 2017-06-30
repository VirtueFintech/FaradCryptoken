pragma solidity ^0.4.11;

contract Admin {

    // pay cryptoyalty 
    function payCryptoyalty(address _to, uint256 _value) public;

    // add money to escrow account
    function creditEscrowAccount(uint256 _value) public;
}


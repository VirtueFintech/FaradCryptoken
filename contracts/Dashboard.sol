pragma solidity ^0.4.11;

contract Dashboard {

    uint256 public escrowAccountBalance = 0;
    uint256 public productionVolume = 0;

    // mapping (hash => mapping (address => uint256)) public productTrace;

    // escrow account deposited
    event EscrowAccountDeposited(uint256 _value);

    // Escrow Account credited
    function creditEscrowAccount(uint256 _value) public;

    // production volume update, overrides the total volume so far
    function updateProductionVolume(uint256 _volume) public;

    // add increments of production volume
    function addProductionVolume(uint256 _increment) public;

}



pragma solidity ^0.4.11;

/*
    Owned contract interface
*/
contract Owner {

    // getter for owner
    function owner() public constant returns (address owner) { owner; }

    // transfer ownership of owner
    function transferOwnership(address _newOwner) public;

    // accept transfer of ownership
    function acceptOwnership() public;
}



pragma solidity ^0.4.11;

import './Owner.sol';

contract OwnerImpl is Owner {
    address public owner;       // current owner
    address public newOwner;    // new owner

    event NewOwner(address _prevOwner, address _newOwner);

    // constructor
    function OwnerImpl() {
        owner = msg.sender;     // set the sender as the owner
    }

    // modifier for isOwner
    modifier isOwner { assert(msg.sender == owner); _; }

    // implement the interfaces
    function transferOwnership(address _newOwner) public isOwner {
        require(_newOwner != owner);
        newOwner = _newOwner;
    }

    // accept as the new owner
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        
        // notify an event of a new owner
        NewOwner(owner, newOwner);

        // set the new owner, with address 0x0
        owner = newOwner;
        newOwner = 0x0;
    }
}


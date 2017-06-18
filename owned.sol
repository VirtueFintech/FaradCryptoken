
pragma solidity ^0.4.11;

contract owned {
    address public owner;   // the owner of this contract

    function owned() {
        owner = msg.sender;
    }

    // modifier to prevent execution, unless owner
    modifier onlyOwner { if (msg.sender != owner) throw; _; }

    // transfer ownership
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

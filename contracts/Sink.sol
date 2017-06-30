pragma solidity ^0.4.11;

import './Operations.sol';

contract Sink is Operations {

    address public sink;
    mapping(address => uint256) public sinkingFunds;

    function Sink() {
        sink = msg.sender;
    }

    // default fallback function
    function() payable {
        // where should this money go?
        sinkingFunds[msg.sender] = add(sinkingFunds[msg.sender], msg.value);
    }

    // only admin can issue transfer
}

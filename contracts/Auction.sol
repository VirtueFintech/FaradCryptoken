
pragma solidity ^0.4.11;

contract Auction {
    uint256 public startTime = 0;
    uint256 public endTime = 0;
    uint256 public supply = 0;
    address public beneficiary;

    // modifiers
    modifier isEarlierThan(uint256 _time) { assert(now < _time); _; }
    modifier isLaterThan(uint256 _time) { assert(now > _time); _; }
    modifier isInBetween(uint256 _begin, uint256 _end) { 
        assert(now > _begin && now < _end); _; 
    }

    function Auction(
        uint256 _startTime, 
        uint256 _endTime,
        uint256 _supply) {
        // some checks
        assert(_endTime > _startTime);

        startTime = _startTime;
        endTime = _endTime;
        supply = _supply;
        beneficiary = msg.sender;
    }

}
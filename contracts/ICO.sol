pragma solidity ^0.4.11;

import './Auction.sol';

contract ICO is Auction {

    function ICO(
        uint256 _startTime, 
        uint256 _endTime,
        uint256 _supply)
        Auction(_startTime, _endTime, _supply)
    {
    }

}


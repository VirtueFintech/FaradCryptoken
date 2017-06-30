pragma solidity ^0.4.11;

import './ICO.sol';

contract SoftSaleICO is ICO {

    function SoftSaleICO(
        uint256 _startTime, 
        uint256 _endTime,
        uint256 _supply)
        ICO(_startTime, _endTime, _supply) {

    }
    
}



pragma solidity ^0.4.11;

import './ICO.sol';

contract PublicICO is ICO {

    function PublicICO(
        uint256 _startTime, 
        uint256 _endTime,
        uint256 _supply,
        address _beneficiary)
        ICO(_startTime, _endTime, _supply, _beneficiary) {

    }

}


pragma solidity ^0.4.11;

import './ICO.sol';
import './FRDCryptoken.sol';

contract PreICO is ICO, FRDCryptoken {

    function PreICO(uint256 _startTime, uint256 _endTime, uint256 _supply)
        ICO(_startTime, _endTime, _supply) 
        FRDCryptoken(_supply)
    {
    }
}


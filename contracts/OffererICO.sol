pragma solidity ^0.4.11;

import './ICO.sol';
import './FRDCryptoken.sol';
import './Sink.sol';

contract OffererICO is ICO, FRDCryptoken, Sink {

    bool public closed = false; 

    // list of wallets for Offeror 
    address public treasury;
    address public sponsor;
    address public coSponsor;
    address public management;
    address public advisor;
    address public consultants;

    function OffererICO(
        uint256 _startTime, 
        uint256 _endTime,
        uint256 _supply)
        ICO(_startTime, _endTime, _supply) 
        FRDCryptoken(_supply)
    {

        // total supply is 25m of FRD. supply the tokens

        // and marked as done.
        closed = true;
    }

    function isClosed() public returns (bool closed) { closed; }

}

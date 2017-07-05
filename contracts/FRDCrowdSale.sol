/**
 * Hisham Ismail <1ofdafew@gmail.com>, and others.
 * Copyright (C) Virtue Fintech FZCO, Dubai
 * All rights reserved.
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy 
 * of this software and associated documentation files (the ""Software""), to 
 * deal in the Software without restriction, including without limitation the 
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
 * sell copies of the Software, and to permit persons to whom the Software is 
 * furnished to do so, subject to the following conditions: 
 *  The above copyright notice and this permission notice shall be included in 
 *  all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
 * THE SOFTWARE.
 *
 */
pragma solidity ^0.4.11;

import './Guarded.sol';
import './Owned.sol';
import './Computable.sol';
import './FRDToken.sol';

contract FRDCrowdSale is Guarded, Owned, Computable {

    uint256 public DURATION = 30 days;          // duration of crowdsale
    uint256 public TOKEN_PRICE_N = 1;           // numerator
    uint256 public TOKEN_PRICE_D = 1000;        // denominator

    string public version = '0.1.1';

    uint256 public startTime = 0;                   // crowdsale start time (in seconds)
    uint256 public endTime = 0;                     // crowdsale end time (in seconds)
    uint256 public totalEtherCap = 1000000 ether;   // current ether contribution cap, temporary
    uint256 public totalEtherContributed = 0;       // ether contributed so far
    address public beneficiary = 0x0;               // address to receive all ether contributions

    FRDToken public token;

    event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);

    function FRDCrowdSale(
        address _token,                 // the FRD token address
        uint256 _startTime,             // the start time
        uint256 _totalEtherCap,         // the total cap for this sale
        address _beneficiary)           // the beneficiary contract address
        isValidAddress(_token)          // token address is not null
        isBefore(_startTime)            // now should be before start time
        isValidAmount(_totalEtherCap)   // total cap must be > 0
        isValidAddress(_beneficiary)    // beneficiary address not null 
    {
        token = FRDToken(_token);       // set the FRDToken address
        startTime = _startTime;
        endTime = startTime + DURATION;
        totalEtherCap = _totalEtherCap;
        beneficiary = _beneficiary;
    }

    function setTotalEtherCap(uint256 _cap) isOwner(msg.sender) public {
        totalEtherCap = _cap;
    }

    function contribute() 
        isInBetween(startTime, endTime)
        public payable {
        processContributions();
    }

    function () payable {
        contribute();
    }

    function processContributions() private {
        // send the amount to beneficiary
        assert(beneficiary.send(msg.value));

        // calculate how much FRD should be received.
        uint256 tokenAmount = computeReturn(msg.value);
        totalEtherContributed = add(totalEtherContributed, msg.value);

        // issue the FRD token to the user
        //  we can use:
        // 1) transfer - which transfer directly
        // 2) approve - where user has to pull
        token.approve(msg.sender, tokenAmount);

        // notify event for this contribution
        Contribution(msg.sender, msg.value, tokenAmount);
    }

    function computeReturn(uint256 _contribution) private returns (uint256) {
        // okay, 1 FRD == uint(ETH * 1000) || 1 Finney == 1 FRD
        return multiply(_contribution, TOKEN_PRICE_D) / TOKEN_PRICE_N;
    }
}


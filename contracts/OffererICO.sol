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

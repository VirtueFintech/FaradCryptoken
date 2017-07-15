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
import './Ownable.sol';
import './SafeMath.sol';
import './FRDCrypToken.sol';

contract FRDCrowdSale is Guarded, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) contributions;          // contributions from public
    uint256 contribCount = 0;

    uint256 public DURATION = 14 days;                  // duration of crowdsale

    string public version = '0.1.1';

    uint256 public startTime = 0;                       // crowdsale start time (in seconds)
    uint256 public endTime = 0;                         // crowdsale end time (in seconds)
    uint256 public totalEtherCap = 1717986918 ether;    // current ether contribution cap, temporary
    uint256 public weiRaised = 0;                       // wei raised so far
    address public wallet = 0x0;                        // address to receive all ether contributions

    uint256 public rate = 0;                            // the rate from wei to FRD

    FRDCrypToken public token;

    event Contribution(address indexed _contributor, uint256 _amount);

    modifier isEtherCapNotReached() {
        assert(weiRaised <= totalEtherCap);
        _;
    }

    modifier isRateUpdated() {
        assert(rate != 0);
        _;
    }

    function FRDCrowdSale(
        uint256 _startTime,             // the start time
        uint256 _totalEtherCap,         // the total cap for this sale
        address _wallet)                // the wallet contract address
        isBefore(_startTime)            // now should be before start time
        isValidAmount(_totalEtherCap)   // total cap must be > 0
        isValidAddress(_wallet)         // wallet address not null 
    {
        token = createFRDContract();
        startTime = _startTime;
        endTime = startTime + DURATION;
        totalEtherCap = _totalEtherCap;
        wallet = _wallet;
    }

    function createFRDContract() internal returns (FRDCrypToken) {
        return new FRDCrypToken();
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return now > endTime;
    }

    function () payable {
        processContributions(msg.sender, msg.value);
    }

    /**
     * Okay, we changed the process flow a bit where the actual FRD to ETH
     * mapping shall be calculated, and pushed to the contract once the
     * crowdsale is over.
     *
     * Then, the user can pull the tokens to their wallet.
     *
     */
    function processContributions(address _contributor, uint256 _weiAmount) payable {
        require(validPurchase());

        uint256 updatedWeiRaised = weiRaised.add(_weiAmount);

        // update state
        weiRaised = updatedWeiRaised;

        // notify event for this contribution
        contributions[_contributor] = contributions[_contributor].add(_weiAmount);
        contribCount += 1;
        Contribution(_contributor, _weiAmount);

        // forware the funds
        forwardFunds();
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        uint256 current = now;

        bool withinPeriod = current >= startTime && current <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        bool withinCap = weiRaised.add(msg.value) <= totalEtherCap;
        return withinPeriod && nonZeroPurchase && withinCap;
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // TODO: post-ICO functions

    // Update rate of FRD to Wei once the calcilation has been done
    // for post-ICO.
    // 
    function updateRate(uint256 _rate) onlyOwner {
        rate = _rate;
    }

    function assignFRD() isRateUpdated onlyOwner {
        for (uint256 i = 0; i < contribCount; i++ ) {

        }
    }


}


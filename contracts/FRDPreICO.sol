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

contract FRDPreICO is Guarded, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) contributions;          // contributions from public
    uint256 contribCount = 0;

    string public version = '0.1.1';

    uint256 public startTime = 1502150400;              // 08/08/2017 @ 12:00am (UTC)
    uint256 public endTime = 1504137599;                // 08/30/2017 @ 11:59pm (UTC)
    uint256 public totalEtherCap = 1200000 ether;       // current ether contribution cap for Pre-ICO
    uint256 public weiRaised = 0;                       // wei raised so far
    address public wallet = 0x0;                        // address to receive all ether contributions

    event Contribution(address indexed _contributor, uint256 _amount);

    modifier isEtherCapNotReached() {
        assert(weiRaised <= totalEtherCap);
        _;
    }

    function FRDPreICO(address _wallet) // the wallet contract address
        isValidAddress(_wallet)         // wallet address not null 
    {
        wallet = _wallet;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return now >= endTime;
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
        contribCount = contribCount + 1; // safer than contribCount++
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

}

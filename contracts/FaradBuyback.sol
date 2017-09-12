/**
 * Copyright (C) Virtue Fintech FZ-LLC, Dubai
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

contract FaradBuyback is Guarded, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) redeemers;    // contributions from FRD holders
    uint256 redeemCount = 0;

    string public version = '0.1.1';

    uint256 public startBlock;
    uint256 public endBlock;

    uint256 public totalRedeemCap;
    uint256 public weiRedeemed = 0;               // wei redeemed in this Buyback

    address public wallet = 0x25D28eC02B63D5216f2Dc2f63c53d17D95612Cf6;

    event Buyback(address indexed _participant, uint256 _amount);

    function FaradBuyback() {
    }

    // change the wallet address
    /// change the wallet to `_wallet`?
    function setWallet(address _wallet) onlyOwner public {
        wallet = _wallet;
    }

    // function to initialize buyback 
    /// start the redeem program at `_startBlock`, ends at `_endBlock` with total redeem of `_redeemCap`
    function initialize(uint256 _startBlock, uint256 _endBlock, uint256 _redeemCap) onlyOwner public {
        startBlock = _startBlock;
        endBlock = _endBlock;
        totalRedeemCap = _redeemCap;
        weiRedeemed = 0;
    }

    // function to start the Buyback 
    /// stop the crowdsale at `_startBlock`
    function setStartBlock(uint256 _startBlock) onlyOwner public {
        startBlock = _startBlock;
    }

    // function to stop the Buyback 
    /// stop the crowdsale at `_endBlock`
    function setEndBlock(uint256 _endBlock) onlyOwner public {
        endBlock = _endBlock;
    }

    // function to stop the Buyback 
    /// stop the crowdsale at `_endBlock`
    function setTotalRedeemCap(uint256 _redeemCap) onlyOwner public {
        totalRedeemCap = _redeemCap;
    }

    // @return true if buyback has started
    function isCommencing() public constant returns (bool) {
        return (block.number >= startBlock && block.number <= endBlock);
    }

    // @return true if buyback has started
    function hasStarted() public constant returns (bool) {
        return block.number >= startBlock;
    }

    // @return true if buyback has ended
    function hasEnded() public constant returns (bool) {
        return block.number >= endBlock;
    }

    function () payable {
        processBuyback(msg.sender, msg.value);
    }

    /**
     * Okay, we changed the process flow a bit where the actual FRD to ETH
     * mapping shall be calculated, and pushed to the contract once the
     * crowdsale is over.
     *
     * Then, the user can pull the tokens to their wallet.
     *
     */
    function processBuyback(address _participant, uint256 _weiAmount) payable {
        require(validPurchase());

        // update state
        weiRedeemed = weiRedeemed.add(_weiAmount);

        // notify event for this contribution
        redeemers[_participant] = redeemers[_participant].add(_weiAmount);
        redeemCount = redeemCount.add(1);

        Buyback(_participant, _weiAmount);

        // forware the funds
        forwardFunds();
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        uint256 current = block.number;

        bool withinPeriod = current >= startBlock && current <= endBlock;
        bool nonZeroPurchase = msg.value != 0;

        // add total wei raised
        uint256 totalFRDRedeemed = weiRedeemed.add(msg.value);
        bool withinCap = totalFRDRedeemed <= totalRedeemCap;

        // check all 3 conditions met
        return withinPeriod && nonZeroPurchase && withinCap;
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

}


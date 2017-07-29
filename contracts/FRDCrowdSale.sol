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

contract FRDCrowdSale is Guarded, Ownable {

  using SafeMath for uint256;

  mapping(address => uint256) contributions;          // contributions from public
  uint256 contribCount = 0;

  uint256 public DURATION = 14 days;                  // duration of crowdsale

  string public version = '0.1.1';

  // uint256 public startBlock = 4243080;                // 07/08/2017 13:00:00, 1502110800
  // uint256 public endBlock = 4307973;                  // 09/13/2017 23:59:59, 1505347199

  uint256 public startBlock = 1381500;                // ropsten, Jul-27-2017 02:40:34 PM +UTC
  uint256 public endBlock = 1419636;                  // 1 week after

  uint256 public totalEtherCap = 1000000 ether;       // Total raised for ICO
  uint256 public weiRaised = 0;                       // wei raised in this ICO

  address public wallet = 0x25D28eC02B63D5216f2Dc2f63c53d17D95612Cf6;

  event Contribution(address indexed _contributor, uint256 _amount);

  function FRDCrowdSale() {
  }

  // function to stop the CrowdSale 
  /// stop the crowdsale at `_endBlock`
  function setEndBlock(uint256 _endBlock) onlyOwner public {
    endBlock = _endBlock;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return block.number >= endBlock;
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
    uint256 current = block.number;

    bool withinPeriod = current >= startBlock && current <= endBlock;
    bool nonZeroPurchase = msg.value != 0;

    // add total wei raised
    uint256 totalWeiRaised = weiRaised.add(msg.value);
    bool withinCap = totalWeiRaised <= totalEtherCap;

    // check all 3 conditions met
    return withinPeriod && nonZeroPurchase && withinCap;
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

}


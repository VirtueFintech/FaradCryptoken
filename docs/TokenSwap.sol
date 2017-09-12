/**
 * Copyright (C) Virtue Fintech FZ-LLC, Dubai
 * All rights reserved.
 * Author: mhi@virtue.finance
 *
 * This code is adapted from OpenZeppelin Project.
 * more at http://openzeppelin.org.
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

library SafeMath {
    function mul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
    }

    function div(uint256 a, uint256 b) internal returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
    }

    function sub(uint256 a, uint256 b) internal returns (uint256) {
    assert(b <= a);
    return a - b;
    }

    function add(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
    }
}

contract Ownable {
    address public owner;

    /** 
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() {
    owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner. 
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to. 
     */
    function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
    owner = newOwner;
    }
    }
}

contract Guarded {

    modifier isValidAmount(uint256 _amount) { 
    require(_amount > 0); 
    _; 
    }

    // ensure address not null, and not this contract address
    modifier isValidAddress(address _address) {
    require(_address != 0x0 && _address != address(this));
    _;
    }

    modifier isValidSymbol(string _symbol) {
    require(bytes(_symbol).length <= 6);
    _;
    }

    // ensures that it's earlier than the given time
    modifier isBefore(uint256 _time) {
    assert(now < _time);
    _;
    }

    // ensures that the current time is between _startTime (inclusive) and _endTime (exclusive)
    modifier isInBetween(uint256 _startTime, uint256 _endTime) {
    assert(now >= _startTime && now < _endTime);
    _;
    }

    modifier isAfter(uint256 _time) {
    assert(now > _time);
    _;
    }
}

contract FaradTokenSwap is Guarded, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) contributions;          // contributions from public
    uint256 contribCount = 0;

    string public version = '0.1.2';

    uint256 public startBlock = 4274557;                // 15/09/2017 00:00:00 GMT, 1505433600
    uint256 public endBlock = 4230637;                  // 30/09/2017 23:59:59 GMT, 1506815999

    uint256 public totalEtherCap = 1184834 ether;       // Total raised for ICO, at USD 211/ether
    uint256 public weiRaised = 0;                       // wei raised in this ICO

    address public wallet = 0x6067f3Fe6e565F515c2c43b84582e1aCC618c521;

    event Contribution(address indexed _contributor, uint256 _amount);

    function FaradTokenSwap() {
    }

    // function to start the Token Sale
    /// start the token sale at `_starBlock`
    function setStartBlock(uint256 _startBlock) onlyOwner public {
        startBlock = _startBlock;
    }

    // function to stop the Token Swap 
    /// stop the token swap at `_endBlock`
    function setEndBlock(uint256 _endBlock) onlyOwner public {
        endBlock = _endBlock;
    }

    // this function is to add the previous token sale balance.
    function setWeiRaised(uint256 _weiRaised) onlyOwner public {
        weiRaised = weiRaised.add(_weiRaised);
    }

    //
    function setWallet(address _wallet) onlyOwner public {
        wallet = _wallet;
    }

    // @return true if token swap event has ended
    function hasEnded() public constant returns (bool) {
        return block.number >= endBlock;
    }

    // @return true if the token swap contract is active.
    function isActive() public constant returns (bool) {
        return block.number >= startBlock && block.number <= endBlock;
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
        bool minPurchase = msg.value >= 0.01 ether;

        // add total wei raised
        uint256 totalWeiRaised = weiRaised.add(msg.value);
        bool withinCap = totalWeiRaised <= totalEtherCap;

        // check all 3 conditions met
        return withinPeriod && minPurchase && withinCap;
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

}



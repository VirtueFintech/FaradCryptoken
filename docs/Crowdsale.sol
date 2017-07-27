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
    requrie(msg.sender == owner);
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
  uint256 public lastBlock = 0;

  uint256 public totalEtherCap = 1000000 ether;       // Total raised for ICO
  uint256 public weiRaised = 0;                       // wei raised in this ICO
  uint256 public previousWeiRaised = 0;               // wei raised in the Pre-ICO

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
    uint256 totalWeiRaised = previousWeiRaised.add(weiRaised.add(msg.value));
    bool withinCap = totalWeiRaised <= totalEtherCap;

    if (!withinCap) {
      if (lastBlock == 0) {
        lastBlock = current;
      }
      // check only 2 conditions
      return nonZeroPurchase && withinPeriod;
    }
    // check all 3 conditions met
    return withinPeriod && nonZeroPurchase && withinCap;
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

}


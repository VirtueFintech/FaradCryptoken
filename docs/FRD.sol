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
  if (msg.sender != owner) {
  throw;
  }
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

/**
 * @title Claimable
 * @dev Extension for the Ownable contract, where the ownership needs to be claimed. 
 * This allows the new owner to accept the transfer.
 */
contract Claimable is Ownable {
  address public pendingOwner;

  /**
   * @dev Modifier throws if called by any account other than the pendingOwner. 
   */
  modifier onlyPendingOwner() {
  if (msg.sender != pendingOwner) {
  throw;
  }
  _;
  }

  /**
   * @dev Allows the current owner to set the pendingOwner address. 
   * @param newOwner The address to transfer ownership to. 
   */
  function transferOwnership(address newOwner) onlyOwner {
  pendingOwner = newOwner;
  }

  /**
   * @dev Allows the pendingOwner address to finalize the transfer.
   */
  function claimOwnership() onlyPendingOwner {
  owner = pendingOwner;
  pendingOwner = 0x0;
  }
}

contract FRDPreICO is Guarded, Ownable {

  using SafeMath for uint256;

  mapping(address => uint256) contributions;          // contributions from public
  uint256 contribCount = 0;

  string public version = '0.1.1';

  // uint256 public startBlock = 4136471;                // 08/08/2017 00:00:00
  // uint256 public endBlock = 4242887;                  // 30/08/2017 23:00:00
  uint256 public startBlock = 1335960;
  uint256 public endBlock = 1500000;
  uint256 public lastBlock = 0;

  uint256 public totalEtherCap = 1200000 ether;       // ether contribution cap for Pre-ICO
  uint256 public weiRaised = 0;                       // wei raised so far
  address public wallet = 0x0;                        // address to receive all ether contributions

  event Contribution(address indexed _contributor, uint256 _amount);

  function FRDPreICO(address _wallet) // the wallet contract address
    isValidAddress(_wallet)         // wallet address not null 
    payable
  {
    wallet = _wallet;
  }

  // @return true if contract has begun 
  function hasBegun() public constant returns (bool) {
    return block.number <= startBlock;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return block.number >= endBlock;
  }

  /// return the current block number 
  function currentBlock() public constant returns (uint256) {
    return block.number;
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
    uint256 current = block.number;

    bool withinPeriod = current >= startBlock && current <= endBlock;
    bool nonZeroPurchase = msg.value != 0;
    bool withinCap = weiRaised.add(msg.value) <= totalEtherCap;
    if (!withinCap) {
      // take all the Ether raise in the current block only.
      if (lastBlock == 0) {
        lastBlock = current;
      }
      // check only 2 conditions
      return withinPeriod && nonZeroPurchase;
    }
    // check all 3 conditions
    return withinPeriod && nonZeroPurchase && withinCap;
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

}

contract FRDCrowdSale is Guarded, Ownable {

  using SafeMath for uint256;

  mapping(address => uint256) contributions;          // contributions from public
  uint256 contribCount = 0;

  uint256 public DURATION = 14 days;                  // duration of crowdsale

  string public version = '0.1.1';

  uint256 public startBlock = 4243080;                // 31/08/2017 00:00:00
  uint256 public endBlock = 4307973;                  // 09/13/2017 23:59:59
  uint256 public lastBlock = 0;

  uint256 public totalEtherCap = 2400000 ether;       // Total raised for ICO
  uint256 public weiRaised = 0;                       // wei raised in this ICO
  uint256 public previousWeiRaised = 0;               // wei raised in the Pre-ICO

  address public wallet = 0x0;                        // address to receive all ether contributions

  event Contribution(address indexed _contributor, uint256 _amount);

  function FRDCrowdSale(address _wallet)    // the wallet contract address
    isValidAddress(_wallet)               // wallet address not null 
  {
    wallet = _wallet;
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

contract ERC20 {
  
  /// total amount of tokens
  uint256 public totalSupply;

  /// @param _owner The address from which the balance will be retrieved
  /// @return The balance
  function balanceOf(address _owner) constant returns (uint256 balance);

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transfer(address _to, uint256 _value) returns (bool success);

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of tokens to be approved for transfer
  /// @return Whether the approval was successful or not
  function approve(address _spender, uint256 _value) returns (bool success);

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender) constant returns (uint256 remaining);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract ERC20Token is ERC20, Guarded {
  using SafeMath for uint256;

  string public standard = 'Cryptoken 0.1.1';

  string public name = '';            // the token name
  string public symbol = '';          // the token symbol
  uint8 public decimals = 0;          // the number of decimals

  // mapping of our users to balance
  mapping (address => uint256) public balances;
  mapping (address => mapping (address => uint256)) public allowed;

  // // event to emit, this is derived
  // event Transfer(address indexed _from, address indexed _to, uint256 _value);
  // event Approval(address indexed _from, address indexed _to, uint256 _value);

  // our constructor. We have fixed everything above, and not as 
  // parameters in the constructor.
  function ERC20Token(string _name, string _symbol,uint8 _decimals) {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  // get token balance
  function balanceOf(address _owner) 
    public constant 
    returns (uint256 balance) 
  {
    return balances[_owner];
  }    

  /**
   * make a transfer. This can be called from the token holder.
   * e.g. Token holder Alice, can issue somethign like this to Bob
   *      Alice.transfer(Bob, 200);     // to transfer 200 to Bob
   */
  /// Initiate a transfer to `_to` with value `_value`?
  function transfer(address _to, uint256 _value) 
    isValidAddress(_to)
    public returns (bool success) 
  {
    // sanity check
    require(_to != address(this));

    // check for overflows
    if (_value < 0 ||
      balances[msg.sender] < _value || 
      balances[_to] + _value < balances[_to])
      throw;

    // 
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    
    // emit transfer event
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * make an approved transfer to another account from vault. This operation
   * should be called after approved operation below.
   * .e.g Alice allow Bob to spend 30 by doing:
   *      Alice.approve(Bob, 30);                 // allow 30 to Bob
   *
   * and Bob can claim, say 10, from that by doing
   *      Bob.transferFrom(Alice, Bob, 10);       // spend only 10
   * and Bob's balance shall be 20 in the allowance.
   */
  /// Initiate a transfer of `_value` from `_from` to `_to`
  function transferFrom(address _from, address _to, uint256 _value)         
    isValidAddress(_from)
    isValidAddress(_to)
    public returns (bool success) 
  {    
    // sanity check
    require(_from != _to && _to != address(this));

    // check for overflows
    if (_value < 0 ||
      balances[_from] < _value || 
      allowed[_from][_to] < _value ||
      balances[_to] + _value < balances[_to])
      throw;

    // update public balance
    allowed[_from][_to] = allowed[_from][_to].sub(_value);        
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);

    // emit transfer event
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * This method is explained further in https://goo.gl/iaqxBa on the
   * possible attacks. As such, we have to make sure the value is
   * drained, before any Alice/Bob can approve each other to
   * transfer on their behalf.
   * @param _spender  - the recipient of the value
   * @param _value    - the value allowed to be spent 
   *
   * This can be called by the token holder
   * e.g. Alice can allow Bob to spend 30 on her behalf
   *      Alice.approve(Bob, 30);     // gives 30 to Bob.
   */
  /// Approve `_spender` to claim/spend `_value`?
  function approve(address _spender, uint256 _value)          
    isValidAddress(_spender)
    public returns (bool success) 
  {
    // sanity check
    require(_spender != address(this));            

    // if the allowance isn't 0, it can only be updated to 0 to prevent 
    // an allowance change immediately after withdrawal
    require(allowed[msg.sender][_spender] == 0);

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * Check the allowance that has been approved previously by owner.
   */
  /// check allowance approved from `_owner` to `_spender`?
  function allowance(address _owner, address _spender)          
    isValidAddress(_owner)
    isValidAddress(_spender)
    public constant returns (uint remaining) 
  {
    // sanity check
    require(_owner != _spender && _spender != address(this));            

    // constant op. Just return the balance.
    return allowed[_owner][_spender];
  }

}

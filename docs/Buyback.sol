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

contract FRDBuyback is Guarded, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) redeemers;    // contributions from FRD holders
    uint256 redeemCount = 0;

    string public version = '0.1.1';

    uint256 public startBlock;
    uint256 public endBlock;

    uint256 public totalRedeemCap;
    uint256 public weiRedeemed = 0;               // wei redeemed in this Buyback

    address public wallet = 0x72834F2c571639879844B6C0059F5f229F86D010;

    event Buyback(address indexed _participant, uint256 _amount);

    function FRDBuyback() {
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


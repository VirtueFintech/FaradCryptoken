
pragma solidity ^0.4.11;

import './Operations.sol';

/**
 * Token is a generic ERC20 Token implementation. The totalSupply is not set
 * in the constructor, and has to be initiated by the implementor/child of this
 * object.
 *
 * Further control like Owner can be added to enforced ownership transfer in the
 * derived object.
 */
contract Token is Operations {

    string public standard = 'Cryptoken 0.1.1';
    string public name = '';            // the token name
    string public symbol = '';          // the token symbol
    uint8 public decimals = 0;          // the number of decimals
    uint256 public totalSupply = 0;     // the total supply in this allocation

    // mapping of our users to balance
    mapping(address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    // make sure the address is not null
    modifier isValidAddress(address _addr) { require(_addr != 0x0); _; }

    // event to emit
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);

    // our constructor. We have fixed everything above, and not as 
    // parameters in the constructor.
    function Token(
        string _name, 
        string _symbol,
        uint8 _decimals) isOwner {

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // some getter functions
    function name() public constant returns (string name) { return name; }
    function symbol() public constant returns (string symbol) { return symbol; }
    function decimals() public constant returns (uint8 decimals) { return decimals; }

    // the attributes of the token
    function totalSupply() public constant returns (uint256 totalSupply) { 
        return totalSupply; 
    }

    // get token balance
    function balanceOf(address _owner) 
        public constant 
        returns (uint256 balance) {
        return balances[_owner];
    }    

    /**
     * make a transfer. This can be called from the token holder.
     * e.g. Token holder Alice, can issue somethign like this to Bob
     *      Alice.transfer(Bob, 200);     // to transfer 200 to Bob
     */
    /// Initiate a transfer to `_to` with value `_value`?
    function transfer(address _to, uint256 _value) 
        public
        isValidAddress(_to)
        returns (bool success) {

        // sanity check
        require(msg.sender != _to);

        // check for overflows
        if (balances[msg.sender] < _value || 
            balances[_to] + _value < balances[_to])
            throw;

        // 
        balances[msg.sender] = subtract(balances[msg.sender], _value);
        balances[_to] = add(balances[_to], _value);
        
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
        public
        isValidAddress(_from)
        isValidAddress(_to)
        returns (bool success) {
    
        // sanity check
        require(_from != _to);

        // check for overflows
        if (_value < 0 ||
            balances[_from] < _value || 
            allowed[_from][msg.sender] < _value ||
            balances[_to] + _value < balances[_to])
            throw;

        // update public balance
        allowed[_from][msg.sender] = subtract(allowed[_from][msg.sender], _value);        
        balances[_from] = subtract(balances[_from], _value);
        balances[_to] = add(balances[_to], _value);

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
        public 
        isValidAddress(_spender)
        returns (bool success) {

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
        public constant 
        isValidAddress(_owner)
        isValidAddress(_spender)
        returns (uint remaining) {

        // constant op. Just return the balance.
        return allowed[_owner][_spender];
    }

}

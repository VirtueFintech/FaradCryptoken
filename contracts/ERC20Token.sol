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

import './ERC20.sol';
import './Guarded.sol';
import './Computable.sol';

/**
 * Token is a generic ERC20 Token implementation. The totalSupply is not set
 * in the constructor, and has to be initiated by the implementor of this
 * contract.
 *
 * Further control like Owner can be added to enforce ownership transfer in the
 * derived contract.
 */
contract ERC20Token is ERC20, Guarded, Computable {

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
        allowed[_from][_to] = subtract(allowed[_from][_to], _value);        
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

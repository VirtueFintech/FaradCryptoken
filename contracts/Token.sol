
pragma solidity ^0.4.11;

import './Owner.sol';
import './Operations.sol';

contract Token is Owner, Operations {

    string public standard = 'FaradCryptoken 0.1.1';
    string public name = '';            // the token name
    string public symbol = '';          // the token symbol
    uint8 public decimals = 0;          // the number of decimals
    uint256 public totalSupply = 0;     // the total supply in this allocation

    // mapping of our users to balance
    mapping(address => uint256) public balanceOf;

    // make sure the address is not null
    modifier isValidAddress(address _addr) { require(_addr != 0x0); _; }

    // event to emit
    event Transfer(address _from, address _to, uint256 _value);
    event ApprovedTransfer(address _from, address _to, uint256 _value);

    // our constructor. We have fixed everything above, and not as 
    // parameters in the constructor.
    function Token(
        string _name, 
        string _symbol,
        uint8 _decimals,        
        uint256 _totalSupply) isOwner {

        require(_totalSupply > 0);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
    }

    // some getter functions
    function name() public constant returns (string name) { name; }
    function symbol() public constant returns (string symbol) { symbol; }
    function decimals() public constant returns (uint8 decimals) { decimals; }

    // the attributes of the token
    function totalSupply() public constant returns (uint256 totalSupply) { 
        totalSupply; 
    }

    // get token balance
    function balanceOf(address _owner) public constant 
            returns (uint256 balance) {
        return balanceOf[_owner];
    }    

    // make transfer
    /// Initiate a transfer to `_to` with value `_value`?
    function transfer(address _to, uint256 _value) public
        isValidAddress(_to)
        returns (bool success) {

        // sanity check
        require(msg.sender != _to && _value > 0);

        // check for overflows
        if (balanceOf[msg.sender] < _value || 
            balanceOf[_to] + _value < balanceOf[_to])
            throw;

        // 
        balanceOf[msg.sender] = subtract(balanceOf[msg.sender], _value);
        balanceOf[_to] = add(balanceOf[_to], _value);
        
        // emit transfer event
        Transfer(msg.sender, _to, _value);
        return true;
    }

    // make an approved transfer to another account from vault
    /// Initiate a transfer of `_value` from `_from` to `_to`
    function transferFrom(address _from, address _to, uint256 _value) public
        isValidAddress(_to)
        isValidAddress(_from)
        returns (bool success) {
    
        // sanity check
        require(_from != _to && _value > 0);

        // check for overflows
        if (balanceOf[_from] < _value || 
            balanceOf[_to] + _value < balanceOf[_to])
            throw;

        // update public balance
        balanceOf[_from] = subtract(balanceOf[_from], _value);
        balanceOf[_to] = add(balanceOf[_to], _value);

        // emit transfer event
        Transfer(_from, _to, _value);
        return true;
    }

    // function claim(uint256 _value) {

    // }

}


pragma solidity ^0.4.11;

import './Token.sol';
import './Operations.sol';

contract TokenImpl is Token, Operations {

    string public standard = 'Token 0.1';
    string public name = '';
    string public symbol = '';
    uint8 public decimals = 0;
    uint256 public totalSupply = 0;

    // mapping of our users to balance
    mapping(address => uint256) public balanceOf;

    // mapping of approved transfer in the vault
    mapping(address => mapping (address => uint256)) public vault;

    event Transfer(address _from, address _to, uint256 _value);

    event ApprovedTransfer(address _from, address _to, uint256 _value);

    // our constructor
    function TokenImpl(string _name, string _symbol, uint8 _decimals) {
        // business rules
        require(bytes(_name).length > 0);
        require(bytes(_symbol).length > 0);

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
    // our modifier for business rules
    modifier isValidAddress(address _addr) { require(_addr != 0x0); _; }

    // make transfer
    function transfer(address _to, uint256 _value) public
        isValidAddress(_to)
        returns (bool success) {

        // 
        balanceOf[msg.sender] = subtract(balanceOf[msg.sender], _value);
        balanceOf[_to] = add(balanceOf[_to], _value);
        
        // emit transfer event
        Transfer(msg.sender, _to, _value);
        return true;
    }

    // make an approved transfer to another account
    function transferFrom(address _from, address _to, uint256 _value) public
        isValidAddress(_to)
        isValidAddress(_from)
        returns (bool success) {
    
        // subtract the vault first.
        vault[_from][msg.sender] = subtract(vault[_from][msg.sender], _value);

        // update public balance
        balanceOf[_from] = subtract(balanceOf[_from], _value);
        balanceOf[_to] = add(balanceOf[_to], _value);

        // emit transfer event
        Transfer(_from, _to, _value);
        return true;
    }

    // approve transfer on behalf
    function approve(address _target, uint256 _value) public
        isValidAddress(_target)
        returns (bool success) {

        // business rules
        require(_value == 0 || vault[msg.sender][_target] == 0);

        // execute the transfer
        vault[msg.sender][_target] = _value;

        // emit approved event
        ApprovedTransfer(msg.sender, _target, _value);
        return true;
    }

}

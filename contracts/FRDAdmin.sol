
pragma solidity ^0.4.11;

import './Admin.sol';
import './Operations.sol';
import './Owner.sol';

contract FRDAdmin is Admin, Owner, Operations {

    uint256 escrowAccountBalance = 0;

    // escrow account deposited
    event EscrowAccountDeposited(uint256 _value);

    // published new FRDCryptoken creation
    event Issuance(address _to, uint256 _value);

    // our constructor
    function FRDAdmin() isOwner {}

    // biz rules
    modifier isValidValue(uint256 _value) { require(_value > 0); _; }
    modifier isValidAddress(address _address) { require(_address != 0x0); _; }

    // Escrow Account credited
    function creditEscrowAccount(uint256 _value)
        public
        isValidValue(_value) {

        // update escrow balance
        escrowAccountBalance = add(escrowAccountBalance, _value);

        // notify balance updated
        EscrowAccountDeposited(_value);
    }

    // function payCryptoyalty(address _to, uint256 _value) 
    //     public
    //     isValidAddress(_to)
    //     isAdmin() {
    // }

}


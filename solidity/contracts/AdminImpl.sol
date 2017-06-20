
pragma solidity ^0.4.11;

import './Admin.sol';
import './Operations.sol';
import './OwnerImpl.sol';

contract AdminImpl is Admin, OwnerImpl, Operations {

    uint256 escrowAccountBalance = 0;

    // escrow account deposited
    event EscrowAccountDeposited(uint256 _value);

    // published new FRDCryptoken creation
    event Issuance(address _to, uint256 _value);

    // our constructor
    function Admin() {}

    // biz rules
    modifier isAdmin() { require(address(this) == 0x0); _; }
    modifier isValidValue(uint256 _value) { require(_value > 0); _; }
    modifier isValidAddress(address _address) { require(_address != 0x0); _; }

    // Escrow Account credited
    function creditEscrowAccount(uint256 _value)
        public
        isValidValue(_value) 
        isAdmin {

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


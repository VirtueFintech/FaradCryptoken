
pragma solidity ^0.4.11;

// Math helper functions
contract Operations {

    // empty constructor
    function Operations() {}

    function add(uint256 _x, uint256 _y) public returns (uint256) {
        uint256 z = _x + _y;
        assert(z >= _x);
        assert(z >= _y);
        return z;
    }

    function subtract(uint256 _x, uint256 _y) public returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    function multiply(uint256 _x, uint256 _y) public returns (uint256) {
        uint256 z = (_x * _y);
        assert(_x == 0 ||  z/_x == _y);
        return z;
    }
}


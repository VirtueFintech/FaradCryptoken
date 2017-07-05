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

import './Ownable.sol';
import './Guarded.sol';

contract Owned is Ownable, Guarded {

    // modifier for isOwner
    modifier isOwner(address _owner) { 
        assert(_owner == owner); 
        _; 
    }

    // constructor
    function Owned() {
        owner = msg.sender;     // set the sender as the owner
    }

    // implement the interfaces
    function transferOwnership(address _newOwner) 
        isOwner(msg.sender) 
        public 
    {
        require(_newOwner != owner);
        newOwner = _newOwner;
    }

    // accept as the new owner
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        
        // notify an event of a new owner
        NewOwner(owner, newOwner);

        // set the new owner, with address 0x0
        owner = newOwner;
        newOwner = 0x0;
    }
}


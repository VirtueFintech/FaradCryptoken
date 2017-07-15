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

import './ERC20Token.sol';
// import './Administerable.sol';

/**
 * FRDCryptoken is the main contract that will be published, including the
 * manufacturing paramters that need to be pushed/published to the blockchain
 * for traceability in the manufaturing process, as well as real-time updates
 * on the escrow balance whenever the cryptoyalty is paid from the manufacturer.
 *
 */
contract FRDCrypToken is ERC20Token {

	// TODO: check the right number
    uint256 public SUPPLY = 1638400000 ether;      // 1.6b supply

    // our constructor, just supply the total supply.
    function FRDCrypToken() 
        ERC20Token('FARAD', 'FRD', 18) 
    {
        totalSupply = SUPPLY;
        balances[msg.sender] = SUPPLY;
    }

}
/**
 * Copyright (C) Virtue Fintech FZ-LLC, Dubai
 * All rights reserved.
 * Author: mhi@virtue.finance 
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
import './Claimable.sol';
import './Guarded.sol';

/**
 * FRDCryptoken is the main contract that will be published, including the
 * manufacturing paramters that need to be pushed/published to the blockchain
 * for traceability in the manufaturing process, as well as real-time updates
 * on the escrow balance whenever the cryptoyalty is paid from the manufacturer.
 *
 */
contract FaradManufacturing is ERC20Token, Guarded, Claimable {

	// This is issued from GAB to FARAD Ltd.
	// 1 unit is equal to 1mF.
	// 
    uint256 public SUPPLY = 1600000000 ether;   // 1.6b ether;

    // our constructor, just supply the total supply.
    function FaradManufacturing() 
        ERC20Token('FARAD Manufacturing', 'FRM', 18) 
    {
        totalSupply = SUPPLY;
        balances[msg.sender] = SUPPLY;
    }

}

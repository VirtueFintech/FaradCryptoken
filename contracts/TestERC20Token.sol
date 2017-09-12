/**
 * Copyright (C) Virtue Fintech FZ-LLC, Dubai
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

/**
 * TestToken is a derived contract from Token that adds the
 * totalSupply parameter to the derived token, as Token is
 * implemented as pure ERC20 token.
 *
 */
contract TestERC20Token is ERC20Token {
  
    function TestERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _supply)
        ERC20Token(_name, _symbol, _decimals) 
    {
        totalSupply = _supply;
        balances[msg.sender] = _supply;
    } 
}

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
const TestERC20Token = artifacts.require('TestERC20Token.sol');

contract('ERC20Token', (accounts) => {
  const supply = 125000000; // 125m
  const owner = accounts[0];
  const dev1 = accounts[1];

  it('shall put 125m for creator', async () => {

    let token = await TestERC20Token.new('Farad', 'FRD', 8, supply);
    let bal = await token.balanceOf.call(owner);
    assert.equal(bal.toNumber(), supply, '125m shall be the balance');
  });

  it('shall show a correct balance', async () => {
    let token = await TestERC20Token.new('Farad', 'FRD', 8, supply);
    let bal = await token.balanceOf.call(owner);
    assert.equal(bal.toNumber(), supply, '125m shall be the balance');
  });

  it('shall make a correct transfer', () => {
    let token = await TestERC20Token.new('Farad', 'FRD', 8, supply);
    let bal = await token.balanceOf.call(owner);
    assert.equal(bal.toNumber(), supply, '125m shall be the balance');

    await token.transfer(dev1, 1000, {from: owner});
    let b1 = await token.balanceOf.call(dev1);
    assert.equal(b1.toNumber(), 1000, 'Expected balance of 1000');

    let b2 = await token.balanceOf.call(owner);
    assert.equal(b2.toNumber(), supply - 1000, 'Expected balance of 1000 less');
  });

});

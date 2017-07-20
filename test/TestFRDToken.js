/**
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

/* global artifacts, contract, it, assert */
/* eslint-disable prefer-reflect */

const FRDToken = artifacts.require('./FRDToken.sol');

contract('FRDToken', (accounts) => {

  // contract constants
  const supply = 135000000; // 135m
  const owner = accounts[0];
  const dev1 = accounts[1]; 
  const dev2 = accounts[2];

  var frd;

  // start the token.
  it('shall deploy the contract', async () => {
    frd = await FRDToken.new();
    assert.notEqual(frd, 0x0, 'should be deployed');
  });
  
  it('shall have the name FARAD', async () => {
    // let frd = await FRDToken.deployed();
    let name = await frd.name();
    assert.equal(name, 'FARAD', 'name should be FARAD');
  });

  it('shall have the symbol FRD', async () => {
    // let frd = await FRDToken.deployed();
    let symbol = await frd.symbol();
    assert.equal(symbol, 'FRD', 'symbol should be FRD');
  });

  it('shall have the decimals of 18', async () => {
    // let frd = await FRDToken.deployed();
    let decimals = await frd.decimals();
    assert.equal(decimals.toNumber(), 18, 'decimals should be 12');
  });

  it('shall create the FRD token with 135m supply', async () => { 
    // let frd = await FRDToken.new();
    let supp = await frd.totalSupply();
    assert.equal(supp.toNumber(), supply, 'supply shall be of 100m');
  });

  it('shall transfer 1000 to dev1 correctly', async () => {
    let frd = await FRDToken.new();
    await frd.transfer(dev1, 1000, {from: owner});

    let ownerBalance = await frd.balanceOf.call(owner);
    assert.equal(ownerBalance.toNumber(), supply - 1000, 'owner balance shall be 1000 less');

    let dev1Balance = await frd.balanceOf.call(dev1);
    assert.equal(dev1Balance.toNumber(), 1000, 'dev1 shall have 1000 by now');
  });

  it('shall allow transfer of 500 from dev1 to dev2 correctly', async () => {
    let frd = await FRDToken.new();
    await frd.transfer(dev1, 1000, {from: owner});

    let ownerBalance = await frd.balanceOf(owner);
    assert.equal(ownerBalance.toNumber(), supply - 1000, 'owner balance shall be 1000 less');

    let dev1Balance = await frd.balanceOf(dev1);
    assert.equal(dev1Balance.toNumber(), 1000, 'dev1 shall have 1000 by now');

    await frd.approve(dev2, 500, {from: dev1});
    let bal1 = await frd.balanceOf(dev1);
    let bal2 = await frd.allowance(dev1, dev2);
    let bal3 = await frd.balanceOf(dev2);

    assert.equal(bal1.toNumber(), 1000, 'shall be still 1000 until drained');
    assert.equal(bal2.toNumber(), 500, 'shall be 500 by now');
    assert.equal(bal3.toNumber(), 0, 'shall be 0 for now');
  });

  it('shall allow dev2 to take up to 500 from dev1', async () => {
    let frd = await FRDToken.new();
    await frd.transfer(dev1, 1000, {from: owner});
    await frd.approve(dev2, 500, {from: dev1});

    let bal1 = await frd.balanceOf(dev1);
    let bal2 = await frd.allowance(dev1, dev2);
    let bald = await frd.balanceOf(dev2);

    assert.equal(bal1.toNumber(), 1000, 'shall be still 1000 until drained');
    assert.equal(bal2.toNumber(), 500, 'shall be 500 by now');
    assert.equal(bald.toNumber(), 0, 'shall be 0 for now');

    // test the transferFrom.
    await frd.transferFrom(dev1, dev2, 100);
    let bal3 = await frd.balanceOf(dev2);
    assert.equal(bal3.toNumber(), 100, 'shall be 100 by now');

    await frd.transferFrom(dev1, dev2, 100);
    let bal4 = await frd.balanceOf(dev2);
    assert.equal(bal4.toNumber(), 200, 'shall be 200 by now');

    await frd.transferFrom(dev1, dev2, 300);
    let bal5 = await frd.balanceOf(dev2);
    assert.equal(bal5.toNumber(), 500, 'shall be 500 by now');

    // this should fail
    try {
        await frd.transferFrom(dev1, dev2, 100);        
    } catch(e) {
        //
        let bal6 = await frd.balanceOf(dev2);
        assert.equal(bal6.toNumber(), 500, 'shall be 500 by now');
    }
  });

  // it('shall fail to transfer 2000 from dev1 to dev2 indefinitely', () => {
  //   return FRDCryptoken.new(supply).then((instance) => {
  //     frd = instance;
  //     return frd.transfer(dev1, 1000, {from: owner});
  //   }).then((res) => {
  //     console.log('txHash:', res.receipt.transactionHash);
  //     return frd.balanceOf.call(owner);
  //   }).then((res) => {
  //     assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
  //     return frd.balanceOf.call(dev1);
  //   }).then((res) => {
  //     assert.equal(1000, res.toNumber(), 'should be 1000');
  //     return frd.transfer(dev2, 2000, {from: dev1});
  //   }).then((res) => {
  //     // should be failed, don't check for res, or error thrown
  //   }).catch((e) => {
  //     console.log('Error in transfering 2000 from dev1 to dev2');
  //     return frd.balanceOf.call(dev2);
  //   }).then((res) => {
  //     assert.equal(0, res.toNumber(), 'dev2 shall have 0');
  //     return frd.balanceOf.call(dev1);
  //   }).then((res) => {
  //     assert.equal(1000, res.toNumber(), 'dev1 shall have 1000 back');
  //   });
  // });

  // it('shall allow dev2 to spend at most 100 from the approved value', () => {
  //   return FRDCryptoken.new(supply).then((instance) => {
  //     frd = instance;
  //     return frd.transfer(dev1, 1000, {from: owner});
  //   }).then((res) => {
  //     // should be successful.
  //     // console.log('Transferred 1000 from', owner, 'to', dev1);
  //     console.log('txHash:', res.receipt.transactionHash);
  //     return frd.balanceOf.call(owner);
  //   }).then((res) => {
  //     assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
  //     // console.log('dev1:', dev1);
  //     return frd.balanceOf.call(dev1);
  //   }).then((res) => {
  //     assert.equal(1000, res.toNumber(), 'should be 1000');
  //     // console.log('dev1:', dev1);
  //     // console.log('dev2:', dev2);
  //     // console.log(dev1, 'approve', dev2, 'to spend at most 100');
  //     return frd.approve(dev2, 100, {from: dev1});
  //   }).then((res) => {
  //     // should be successful.
  //     // console.log(dev1, 'approved 100 to', dev2)
  //     console.log('txHash:', res.receipt.transactionHash);

  //     // and allowable balance should be 100
  //     return frd.allowance.call(dev1, dev2);
  //   }).catch((e) => {
  //     console.log('Error in approving 100 to dev2:', e);
  //     throw new Error(e);
  //   }).then((res) => {
  //     // console.log('Allowance is', res.toNumber());
  //     assert.equal(res.toNumber(), 100, 'shall be 100 in allowance');

  //     // and dev2 can withdraw 50 out of it, can he?
  //     // console.log('Calling transferFrom for', dev1, 'to', dev2);
  //     return frd.transferFrom(dev1, dev2, 50, {from: dev2});
  //   }).then((res) => {
  //     // should be successful.
  //     // console.log(dev2, 'transferFrom', dev1, 'of 50')
  //     console.log('txHash:', res.receipt.transactionHash);
  //     // allowance balance shall be 50?
  //     return frd.allowance.call(dev1, dev2);
  //   }).then((res) => {
  //     assert.equal(res.toNumber(), 50, 'balance in allowance shall be 50');
  //     // and balance is 50 as well
  //     return frd.balanceOf.call(dev2);
  //   }).then((res) => {
  //     assert.equal(res.toNumber(), 50, 'balanceOf shall be 50');
  //   }).catch((e) => {
  //     console.log('Exiting test case:', e);
  //   });

  // });

});

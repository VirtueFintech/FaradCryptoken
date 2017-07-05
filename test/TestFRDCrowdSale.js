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

/* global artifacts, contract, it, assert */
/* eslint-disable prefer-reflect */

const FRDCrowdSale = artifacts.require('./FRDCrowdSale.sol');
const FRDToken = artifacts.require('./FRDToken.sol');
const Utils = require('./Utils');

let token;
let tokenAddress;

let startTime = Math.floor(Date.now() / 1000) + 30*24*60*60;          // crowdsale hasn't started
let startTimeInProgress = Math.floor(Date.now() / 1000) - 12*60*60;   // ongoing crowdsale
let startTimeFinished = Math.floor(Date.now() / 1000) - 30*24*60*60;  // ongoing crowdsale
let duration = 30*24*60*60;

let etherCap = 1000000 * 1e+18; // 1m Ether
let beneficiary = '0xe4b19fe91de2732717d77fa5e01e062fff56b4fa';

async function end(time) { return startTime + duration }

async function prepareCrowdsale(time) {
  console.log('Preparing CrowdSale...');
  return await FRDCrowdSale.new(tokenAddress, time, etherCap, beneficiary);
}

contract('FRDCrowdSale', (accounts) => {

  // some of the accounts
  let owner = accounts[0];
  let dev1 = accounts[1];
  let dev2 = accounts[2];

  before(async () => {
    console.log('Preparing new FRD...');
    let token = await FRDToken.new();
    tokenAddress = token.address;
  });

  it('shall prepare the crowdsale environment', async () => {
    let sale = await prepareCrowdsale(startTime);
    let token = await sale.token.call();  // get the token address

    console.log('Testing sale and token...');
    assert.equal(token, tokenAddress, 'token address should be the same');

    let start = await sale.startTime.call();
    assert.equal(start.toNumber(), startTime);

    let endTime = await sale.endTime.call();
    let duration = await sale.DURATION.call();
    assert.equal(endTime.toNumber(), startTime + duration.toNumber());

    let beneficiaryAddress = await sale.beneficiary.call();
    assert.equal(beneficiary, beneficiaryAddress);

    let cap = await sale.totalEtherCap.call();
    assert.equal(cap.toNumber(), etherCap);
  });

  it('shall not throw', async () => {
    try {
      let sale = await FRDCrowdSale.new(tokenAddress, startTime, etherCap, beneficiary);
      assert(true, 'should not throw');
    } catch(e) {
      return Utils.ensureException(e);
    }
  });

  it('shall throw for invalid token address', async () => {
    try {
      let sale = await FRDCrowdSale.new('0x0', startTime, etherCap, beneficiary);
      assert(false, 'should throw');
    } catch(e) {
      return Utils.ensureException(e);
    }
  });

  it('shall throw for invalid begin time', async () => {
    try {
      let sale = await FRDCrowdSale.new(tokenAddress, startTimeInProgress, etherCap, beneficiary);
      assert(false, 'should throw');
    } catch(e) {
      return Utils.ensureException(e);
    }
  });
  
  it('shall throw for invalid ether cap', async () => {
    try {
      let sale = await FRDCrowdSale.new(tokenAddress, startTime, 0, beneficiary);
      assert(false, 'should throw');
    } catch(e) {
      return Utils.ensureException(e);
    }
  });

  it('shall throw for invalid beneficiary address', async () => {
    try {
      let sale = await FRDCrowdSale.new(tokenAddress, startTime, etherCap, '0x0');
      assert(false, 'should throw');
    } catch(e) {
      return Utils.ensureException(e);
    }
  });

});

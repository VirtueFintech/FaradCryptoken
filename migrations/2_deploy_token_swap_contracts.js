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

var Migrations = artifacts.require("./Migrations.sol"); 
var SafeMath = artifacts.require("./SafeMath.sol");

var Claimable = artifacts.require("./Claimable.sol");
var Guarded = artifacts.require("./Guarded.sol");
var Ownable = artifacts.require("./Ownable.sol");

// var ERC20 = artifacts.require("./ERC20.sol");
// var ERC20Token = artifacts.require("./ERC20Token.sol");
var FaradTokenSwap = artifacts.require("./FaradTokenSwap.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);

  deployer.deploy(Claimable);
  deployer.deploy(Guarded);
  deployer.deploy(Ownable);
  
  // deployer.deploy(ERC20);
  // deployer.deploy(ERC20Token);
  deployer.deploy(FaradTokenSwap);
  
  deployer.link(SafeMath, FaradTokenSwap);
  // deployer.link(SafeMath, ERC20Token);
};

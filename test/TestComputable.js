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
const Computable = artifacts.require('TestComputable.sol');

contract('Computable', (accounts) => {
  it('shall add 1 and 2 correctly', () => {
    var op;
    return Computable.new().then((instance) => {
      op = instance;
      return op.testAdd.call(1, 2);
    }).then((res) => {
      assert.equal(res.toNumber(), 3, 'should be 3');
    });
  });

  it('shall add 1000 and 1002 correctly', () => {
    var op;
    return Computable.new().then((instance) => {
      op = instance;
      return op.testAdd.call(1000, 1002);
    }).then((res) => {
      assert.equal(res.toNumber(), 2002, 'should be 2002');
    });
  });

  it('shall deduct 500 from 10,000 correctly', () => {
    var op;
    return Computable.new().then((instance) => {
      op = instance;
      return op.testSubtract.call(10000, 500);
    }).then((res) => {
      assert.equal(res.toNumber(), 9500, 'should be 9500');
    });
  });

  it('shall deduct 500 from 501 correctly', () => {
    var op;
    return Computable.new().then((instance) => {
      op = instance;
      return op.testSubtract.call(501, 500);
    }).then((res) => {
      assert.equal(res.toNumber(), 1, 'should be 1');
    });
  });

  it('shall multiply 500 by 4 correctly', () => {
    var op;
    return Computable.new().then((instance) => {
      op = instance;
      return op.testMultiply.call(500, 4);
    }).then((res) => {
      assert.equal(res.toNumber(), 2000, 'should be 2000');
    });
  });

});
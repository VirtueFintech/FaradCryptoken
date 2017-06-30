
var Oper = artifacts.require('TestOperations.sol');

contract('Operations', (accounts) => {
  it('shall add 1 and 2 correctly', () => {
    var op;
    return Oper.new().then((instance) => {
      op = instance;
      return op.testAdd.call(1, 2);
    }).then((res) => {
      assert.equal(res.toNumber(), 3, 'should be 3');
    });
  });

  it('shall add 1000 and 1002 correctly', () => {
    var op;
    return Oper.new().then((instance) => {
      op = instance;
      return op.testAdd.call(1000, 1002);
    }).then((res) => {
      assert.equal(res.toNumber(), 2002, 'should be 2002');
    });
  });

  it('shall deduct 500 from 10,000 correctly', () => {
    var op;
    return Oper.new().then((instance) => {
      op = instance;
      return op.testSubtract.call(10000, 500);
    }).then((res) => {
      assert.equal(res.toNumber(), 9500, 'should be 9500');
    });
  });

  it('shall deduct 500 from 501 correctly', () => {
    var op;
    return Oper.new().then((instance) => {
      op = instance;
      return op.testSubtract.call(501, 500);
    }).then((res) => {
      assert.equal(res.toNumber(), 1, 'should be 1');
    });
  });

  it('shall multiply 500 by 4 correctly', () => {
    var op;
    return Oper.new().then((instance) => {
      op = instance;
      return op.testMultiply.call(500, 4);
    }).then((res) => {
      assert.equal(res.toNumber(), 2000, 'should be 2000');
    });
  });

});
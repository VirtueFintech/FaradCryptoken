
var FRD = artifacts.require('./FRDCryptoken.sol');

contract('FRD', function(accounts) {

  // contract variables;
  //
  var frd;  // FRD instance
  const supply = 100000000; // 100m
  const owner = accounts[0];
  const dev1 = accounts[1]; 
  const dev2 = accounts[2]; 

  it('shall create the FRD token with 100m supply', function() {
    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.balanceOf.call(owner);
    }).then(function(bal) {
      assert.equal(supply, bal.toNumber(), 'Expect 100m supply');
    });
  });

  it('shall transfer 1000 to dev1 correctly', function() {
    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.transfer(dev1, 1000);
    }).then(function(res) {
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(owner);
    }).then(function(res) {
      assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'should be 1000');
    }).catch(function(e) {
      console.log('error:', e);
    });
  });

  it('shall allow transfer of 500 from dev1 to dev2 correctly', function() {
    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.transfer(dev1, 1000, {from: owner});
    }).then(function(res) {
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(owner);
    }).then(function(res) {
      assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'should be 1000');
      // set the allowance first
      return frd.approve(dev2, 500, {from: dev1});
    }).then(function(res) {
      return frd.transferFrom(dev1, dev2, 500, {from: dev2});
    }).then(function(res) {
      // should be successful.
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(dev2);
    }).then(function(res) {
      assert.equal(500, res.toNumber(), 'dev2 shall have 500');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(500, res.toNumber(), 'dev1 shall have 500 now');
    }).catch(function(e) {
      console.log('error:', e);
    });
  });

  it('shall fail to transfer 2000 from dev1 to dev2 indefinitely', function() {
    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.transfer(dev1, 1000);
    }).then(function(res) {
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(owner);
    }).then(function(res) {
      assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'should be 1000');
      return frd.transfer(dev2, 2000, {from: dev1});
    }).then(function(res) {
      // should be failed, don't check for res, or error thrown
    }).catch(function(e) {
      console.log('Error in transfering 2000 from dev1 to dev2');
      return frd.balanceOf.call(dev2);
    }).then(function(res) {
      assert.equal(0, res.toNumber(), 'dev2 shall have 0');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'dev1 shall have 1000 back');
    });
  });

  it('shall allow dev2 to spend at most 100 from the approved value', function() {
    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.transfer(dev1, 1000, {from: owner});
    }).then(function(res) {
      // should be successful.
      // console.log('Transferred 1000 from', owner, 'to', dev1);
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(owner);
    }).then(function(res) {
      assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
      // console.log('dev1:', dev1);
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'should be 1000');
      // console.log('dev1:', dev1);
      // console.log('dev2:', dev2);
      // console.log(dev1, 'approve', dev2, 'to spend at most 100');
      return frd.approve(dev2, 100, {from: dev1});
    }).then(function(res) {
      // should be successful.
      // console.log(dev1, 'approved 100 to', dev2)
      console.log('txHash:', res.receipt.transactionHash);

      // and allowable balance should be 100
      return frd.allowance.call(dev1, dev2);
    }).catch(function(e) {
      console.log('Error in approving 100 to dev2:', e);
      throw new Error(e);
    }).then(function(res) {
      // console.log('Allowance is', res.toNumber());
      assert.equal(res.toNumber(), 100, 'shall be 100 in allowance');

      // and dev2 can withdraw 50 out of it, can he?
      // console.log('Calling transferFrom for', dev1, 'to', dev2);
      return frd.transferFrom(dev1, dev2, 50, {from: dev2});
    }).then(function(res) {
      // should be successful.
      // console.log(dev2, 'transferFrom', dev1, 'of 50')
      console.log('txHash:', res.receipt.transactionHash);
      // allowance balance shall be 50?
      return frd.allowance.call(dev1, dev2);
    }).then(function(res) {
      assert.equal(res.toNumber(), 50, 'balance in allowance shall be 50');
      // and balance is 50 as well
      return frd.balanceOf.call(dev2);
    }).then(function(res) {
      assert.equal(res.toNumber(), 50, 'balanceOf shall be 50');
    }).catch(function(e) {
      console.log('Exiting test case:', e);
    });

  });

});
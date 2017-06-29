
var FRD = artifacts.require('./FRDCryptoken.sol');

contract('FRD', function(accounts) {

  // contract variables;
  //
  var frd;  // FRD instance
  var supply = 100000000; // 100m
  var owner = accounts[0];
  var dev1 = 0x47204B7AF24dab0fd2d8E65Ed679612Ee45AC40B;
  var dev2 = 0xf969a1BCF4C36871fe5571b24e65f720f115DdC2;

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
      return frd.transfer(dev1, 1000);
    }).then(function(res) {
      console.log('txHash:', res.receipt.transactionHash);
      return frd.balanceOf.call(owner);
    }).then(function(res) {
      assert.equal(supply - 1000, res.toNumber(), 'should be 1000 less');
      return frd.balanceOf.call(dev1);
    }).then(function(res) {
      assert.equal(1000, res.toNumber(), 'should be 1000');
      return frd.transferFrom(dev1, dev2, 500);
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
      return frd.transferFrom(dev1, dev2, 2000);
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

});

var FRD = artifacts.require('./FRDCryptoken.sol');

contract('FRD', function(accounts) {

  it('shall create the FRD token with 100m supply', function() {
    var supply = 100000000; // 100m
    var frd;  // FRD instance
    var owner = accounts[0];

    return FRD.new(supply).then(function(instance) {
      frd = instance;
      return frd.balanceOf.call(owner);
    }).then(function(bal) {
      var expected = bal.toNumber();
      assert.equal(supply, expected, 'Expect 100m supply');
    });
  });

});
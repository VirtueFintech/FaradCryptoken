
var Token = artifacts.require('./Token.sol');

contract('Token', function(accounts) {
  it('shall put 10m for creator', function() {
    var expected = 100000000; // 100m

    return Token.new('Farad', 'FRD', 8, expected).then(function(instance) {
      return instance.balanceOf.call(accounts[0]);
    }).then( function(balance) {
      assert.equal(balance.valueOf(), expected, "100m wasn't in the first account");
    });
  });

  it('shall show a correct balance', function() {
    // transfer 1000 to addr1
    var token;
    var tokenBalance;
    var expected = 100000000; // 100m

    return Token.new('Farad', 'FRD', 8, expected).then(function(instance) {
      token = instance;
      return token.balanceOf.call(accounts[0]);
    }).then( function(balance) {
      tokenBalance = balance.toNumber();
    }).then( function() {
      assert.equal(tokenBalance, expected, "100m is expected");
    });
  });

  it('shall make a correct transfer', function() {
    var expected = 100000000; // 100m
    var token;
    var owner = accounts[0];
    var dev1 = 0x47204B7AF24dab0fd2d8E65Ed679612Ee45AC40B;

    return Token.new('Farad', 'FRD', 8, expected).then(function(instance) {
      token = instance;

      // get balance first. should be 100m
      return token.balanceOf.call(owner);
    }).then(function(balance) {
      // balance should be 100m
      var actual = balance.toNumber();
      assert.equal(actual, expected, 'Expected 100m balance');
    }).then(function() {
      // make a transfer
      token.transfer(dev1, 1000);

      // get the balance
      return token.balanceOf.call(dev1);
    }).then(function(dev1_bal) {
      // dev1 balance should be 1000
      var actual = dev1_bal.toNumber();
      assert.equal(actual, 1000, 'Expected balance of 1000');
    }).then(function() {
      // get the acc0 balance
      return token.balanceOf.call(owner);
    }).then(function(m_bal) {
      // expect balance of account[0] to be 1000 less
      var bal = expected - 1000;
      var actual = m_bal.toNumber();      
      assert.equal(actual, bal, 'Expected to be 1000 less from 100m');
    })
  });

  it('shall allow transfer from acc0 to dev1', function() {
    var supply = 100000000; // 100m
    var token;
    var owner = accounts[0];
    var dev1 = 0x47204B7AF24dab0fd2d8E65Ed679612Ee45AC40B;

    return Token.new('Farad', 'FRD', 8, supply).then(function(instance) {
      token = instance;

      // make a transfer
      token.transferFrom(owner, dev1, 1000);
    }).then(function() {
      // check the balance for dev1
      return token.balanceOf.call(dev1);
    }).then(function(dev1_bal) {
      var actual = dev1_bal.toNumber();
      assert.equal(actual, 1000, 'Expected to be 1000');
    }).then(function() {
      // check balance of owner
      return token.balanceOf.call(owner);
    }).then(function(owner_bal) {
      var actual = owner_bal.toNumber();
      assert.equal(actual, supply - 1000, 'Extected to be 1000 less');
    });
  });

  it('shall allow dev1 to claim money', function() {
    var supply = 100000000; // 100m
    var token;
    var owner = accounts[0];
    var dev1 = 0x47204B7AF24dab0fd2d8E65Ed679612Ee45AC40B;

    return Token.new('Farad', 'FRD', 8, supply).then(function(instance) {
      token = instance;
    });

  });  

});

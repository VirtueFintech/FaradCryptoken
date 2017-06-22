//
// file: farad_token.sol
// creator: Hisham Ismail <mhishami@gmail.com>
// description: FRD CryptoToken crowd sale implementation, which is tied to 
//              manufacturing process of Ultra Capacitor productions
//
pragma solidity ^0.4.11;

import './IOwner.sol';

contract FaradCryptToken is IOwner {

    string public name;             // the token name
    string public symbol;           // the token symbol
    uint8 public dscimals;          // set up to 8 decimals

    // the public registers
    uint public totalSupply;        // the total supply
    uint public initialSupply;      // the initial supply of FRD

    // manufcturing related.
    uint public contractVolume;     // volume of Farads to produce in contract
    uint public productionVolume;   // the current production volume

    // sales, pre-ICO and redeem volume
    uint public redeemVolume;       // the current coin redeemed value
    uint public preICOVolume;       // the preICO volume
    uint public salesVolume;        // the public (post pre-ICO) volume

    // register mappings {addr -> volume} for our subscribers/buyers
    mapping(address => uint) public balances;

    // sales related
    uint public preICOBegin;        // timestamp for the start of pre-ICO
    bool preICOEnded;               // pre-ICO ends
    uint public salesBegin;         // timstamp for the start of sales
    bool salesEnded;                // sales ended

    // payment related
    bool executeSplit;              // marker for split coins execution

    // escrow account related
    uint escrowAccountBalance;      // the escrow acount balance for buyback

    // Events to publish
    // ------------------------------------------------------------------------
    //
    // Pre-ICO event ended, and updated the total Pre-ICO collection
    event PreICOEnded(uint collected);

    // Sales ended event, with total collection published
    event SalesEnded(uint collected);

    // Production update from factory
    event ProductinVolumeUpdate(uint _volume);

    // Executed when royalty is being paid, and how much the resulting balance 
    event RoyaltyPaidExecuted(address _user, uint resultingVolume);

    // Executed when split coin happens, and how much the buyer owns after split
    event SplitCoinExecuted(address _user, uint resultingVolume);

    // Notify when somebody redeem the coin
    event TokenRedeemed(address _user, uint volume);

    // Notify when money is deposited into Escrow Account for buyback
    event EscrowAccountDeposited(uint volume);

    // Notify when user-to-{user|entity} transfer happens
    event UserTransfer(address _from, address _to, uint volume);

    // Notify when user can withdraw the buy amount once approved
    event Withdraw(address _user, uint volume);

    function FaradCryptToken(
        address _centralMinter,     // the central minter
        uint _preICOTime,           // the pre-ICO time
        uint _salesTime,            // the sales time
        uint _initialSupply,        // the initialSupply
        uint _contractVolume) {     // the contract volume
    
        name = "Farad Cryptoken";
        symbol = "FRD";
        if (_centralMinter != 0) owner = _centralMinter;
        balances[owner] = _initialSupply;  // give to minter all tokens

        contractVolume = _contractVolume;
        productionVolume = 0;       // no producion yet, until the proceeds
        redeemVolume = 0;           // no token redeemed yet
        preICOVolume = 0;           // no pre-ICO volume yet
        salesVolume = 0;            // no sales volume yet

        // the timestamp, and marker
        preICOBegin = _preICOTime;
        preICOEnded = false;
        salesBegin = _salesTime;
        salesEnded = false;

        // escrow account
        escrowAccountBalance = 0;   // no deposit yet.
    }

    // -------------------------------------------------------------------------
    // External functions

    // -------------------------------------------------------------------------
    // Private functions

    // -------------------------------------------------------------------------
    // Public functions
}


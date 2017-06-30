pragma solidity ^0.4.11;

import './OffererICO.sol';

contract StateMachine {
    enum Stages {
        AcceptingOfferor,
        AcceptingPreICO,
        AcceptingSoftSale,
        AcceptingPublicSale,
        Closure,
        Closed
    }

    Stages public stage = Stages.AcceptingOfferor;
    uint public creationTime = now;

    // ICO state
    OffererICO public offerICO;
    
    modifier atStage(Stages _stage) { require(stage == _stage); _; }

    modifier timedTransitions() {
        if (stage == Stages.AcceptingOfferor) {
            if (offerICO.isClosed() == true) {                
                nextStage();            
            }
        }
        if (stage == Stages.AcceptingPreICO &&
            now > creationTime + 5 days) {
            nextStage();
        }
        if (stage == Stages.AcceptingSoftSale &&
            now > creationTime + 10 days) {
            nextStage();
        }
        if (stage == Stages.AcceptingPublicSale &&
            now > creationTime + 15 days) {
            nextStage();
        }
        // other stage transitions 
        _;
    }

    modifier transitionNext() { _; nextStage(); }

    function nextStage() internal {
        stage = Stages(uint(stage) + 1);
    }

    function closure() 
        timedTransitions
        atStage(Stages.Closure)
        transitionNext
    {

    }

    function closed() 
        timedTransitions
        atStage(Stages.Closed)
    {

    }


}
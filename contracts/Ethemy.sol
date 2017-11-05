pragma solidity ^0.4.9;

// This document is part of the Lunyr coding challenge. If you would like to participate
// please email support át lunyr döt cōm with a description of any bugs you find in this contract
// including what the function should do, what it actually does, what are the consequences
// of the bug (how to abuse it), and how to fix it. Happy Hacking
// RTFM: https://solidity.readthedocs.io/en/develop/

// (ʘ‿ʘ)(ʘ‿ʘ)(ʘ‿ʘ)

// THIS CONTRACT CONTAINS BUGS - DO NOT USE
contract Ethemy {


   /// Mapping of ether shares of the contract.
   mapping(address => uint) shares;
   address owner;
   address[] shareholders;
   event FailedSend(address, uint);

   function Ethemy() {
      owner = msg.sender;
   }

    function () payable {
        // Shares balance is overridden every time a shareHolder sends money. 
        shares[msg.sender] = msg.value;
        // Also, by not adding the sender to shareholders, dispense() will not 
        // dispense all shares back to all users who sent this contract money. 
    }

    function addShareholder(address shareholder) {
        // Using tx.origin exposes the contract to an owner impersonation attack. 
        // If the owner interacts with a malicious contract, the malicious contract could execute
        // this function successfully (since tx.origin checks for transaction originator, not msg sender)
        require(tx.origin == owner);
        shareholders.push(shareholder);
    }

   /// Withdraw your share.
    function withdraw() {
        // By attempting a send in the conditional, this function is exposed to a re-entrancy attack
        // A malicious user could recursively call this function, and drain the contract, 
        // before its shares are ever reset to 0.
        if (msg.sender.send(shares[msg.sender])) {
            shares[msg.sender] = 0;
        } else {
            FailedSend(msg.sender, shares[msg.sender]);
        }
    }

   function dispense() {
      require(msg.sender == owner);
      address shareholder;
      // var is equal to uint8, with a max val of 255. This may be intentional, 
      // But to avoid an infinite loop, an upper bound on shareholders size should be set 
      // to be less than 255. 
      for (var i = 0; i < shareholders.length; i++) {
         shareholder = shareholders[i];
         uint sh = shares[shareholder];
         shares[shareholder] = 0;
         shareholder.send(sh);
      }
   }

}
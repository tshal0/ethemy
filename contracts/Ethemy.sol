pragma solidity ^0.4.9;

// This document is part of the Lunyr coding challenge. If you would like to participate
// please email support át lunyr döt cōm with a description of any bugs you find in this contract
// including what the function should do, what it actually does, what are the consequences
// of the bug (how to abuse it), and how to fix it. Happy Hacking
// RTFM: https://solidity.readthedocs.io/en/develop/

// (ʘ‿ʘ)(ʘ‿ʘ)(ʘ‿ʘ)

// THIS CONTRACT CONTAINS BUGS - DO NOT USE

// Bugs found thus far:

// 1. var used instead of uint; All addresses stored after the 255th will be have their ether sent to the original 255 addresses when dispense() is called.
// 2. Re-entrancy: Withdraw sends ether before detecting a failure, a contract can be designed to recursively call withdraw()
// 3. tx.origin walks all the way up the call stack to find the originating owner of the transaction; a vulnerable user could interact with a malicious contract that then 
//    calls addShareholder however many times they want.
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
      shares[msg.sender] = msg.value;
   }

   function addShareholder(address shareholder) {
      require(tx.origin == owner);
      shareholders.push(shareholder);
   }

   /// Withdraw your share.
   function withdraw() {
     if (msg.sender.send(shares[msg.sender])) {
         shares[msg.sender] = 0;
      } else {
         FailedSend(msg.sender, shares[msg.sender]);
      }
   }

   function dispense() {
      require(msg.sender == owner);
      address shareholder;
      for (var i = 0; i < shareholders.length; i++) {
         shareholder = shareholders[i];
         uint sh = shares[shareholder];
         shares[shareholder] = 0;
         shareholder.send(sh);
      }
   }

}
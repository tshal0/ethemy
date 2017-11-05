pragma solidity ^0.4.9;

// This document is part of the Lunyr coding challenge. If you would like to participate
// please email support át lunyr döt cōm with a description of any bugs you find in this contract
// including what the function should do, what it actually does, what are the consequences
// of the bug (how to abuse it), and how to fix it. Happy Hacking
// RTFM: https://solidity.readthedocs.io/en/develop/

// (ʘ‿ʘ)(ʘ‿ʘ)(ʘ‿ʘ)

// THIS CONTRACT CONTAINS BUGS - DO NOT USE

// Bugs found thus far: '0xa8a0d322b1e77575afb8d9dd79859d876b199c6c',

// 1. var used instead of uint; All addresses stored after the 255th will be have their ether sent to the original 255 addresses when dispense() is called.
// 2. Re-entrancy: Withdraw sends ether before detecting a failure, a contract can be designed to recursively call withdraw()
// 3. tx.origin walks all the way up the call stack to find the originating owner of the transaction; a vulnerable user could interact with a malicious contract that then 
//    calls addShareholder however many times they want.
// 4. Multiple payments resulted in overridden share amounts, giving the owner of the contract free eth.
// 5. No suiciding the contract, meaning ether could be lost forever.
contract Dev {


    // Added an upper bound to the contract with regard to shareholder addresses.
    mapping(address => uint) shares;
    address owner;
    address[] shareholders;
    uint constant MAX_SHAREHOLDERS = 250;   // Defining an upper bound on shareholder amount due to gas costs of dispense()
    

    event FailedSend(address, uint);

    event FailedAddShareholder(bytes32);

    function Dev() {
        owner = msg.sender;
    }

    // All payments will be added to balance and share balance stored
    function () payable {
        // If sender is unintialized, add them to shareholders
        if (shares[msg.sender] == 0) {
            shareholders.push(msg.sender);
        }
        // Add the sent payment to an existing balance 
        shares[msg.sender] = shares[msg.sender] + msg.value;
    }

    function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    function addAddress(address _addr) {
        require(msg.sender == owner);
        if (shareholders.length < MAX_SHAREHOLDERS) {
            shareholders.push(_addr);
            shares[_addr] = 1;
        } else {
            FailedAddShareholder("MAX_SHAREHOLDERS");
        }
    }

    function withdraw() {
        if (shares[msg.sender] > 0) {
            uint sh = shares[msg.sender];
            shares[msg.sender] = 0;
            msg.sender.send(sh);
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

    function withdrawAll() {
        require(msg.sender == owner);
        owner.send(this.balance); // Send all funds to the owner
    }

    function getLength() constant returns (uint) {
        return shareholders.length;
    }

    function getAddresses() external returns (address[]) {
        return shareholders;
    }

    // Return 0 if address is unintialized or simply de-initialized. Otherwise send balance
    function getShares(address _addr) external returns (uint) {
        return shares[_addr];
    }

}
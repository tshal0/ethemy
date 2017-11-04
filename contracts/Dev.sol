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
contract Dev {


    /// Mapping of ether shares of the contract.
    mapping(address => uint) shares;
    address owner;
    address[] shareholders;

    function Dev() {
        owner = msg.sender;
    }

    function () payable {
        shares[msg.sender] = msg.value;
    }

    function addAddress(address _addr) {
        shareholders.push(_addr);
    }

    function getLength() constant returns (uint) {
        return shareholders.length;
    }

    function getAddresses() external returns (address[]) {
        return shareholders;
    }

}
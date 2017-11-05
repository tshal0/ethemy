// This contract is a response to the Lunyr coding challenge. 
// Written by:  Thomas Shallenberger (Twitter, Github, Facebook username: valkn0t)
// Date:        11/4/2017
// In here, I go over the bugs and additional features I added as I built this contract to be
// interfaced with by a React.js front end. All features were tested using testrpc. 
// With additional time I'd test on Ropsten. 


pragma solidity ^0.4.9;


contract Lunyr {


    // Added an upper bound to the contract with regard to shareholder addresses.
    mapping(address => uint) shares;
    address owner;
    address[] shareholders;
    // Defining an upper bound on shareholder amount due to gas costs of dispense(), 
    // And because without it using a var (uint8) would result in an infinite loop once 
    // shareholders.length went > 255
    uint constant MAX_SHAREHOLDERS = 255;

    event FailedSend(address, uint);

    event FailedAddShareholder(bytes32);

    function Lunyr() {
        owner = msg.sender;
    }

    // All payments will be added to balance and share balance stored
    function () payable {
        // If sender is unintialized, add them to shareholders
        // WARNING: Duplicate shareholders may be added if they withdraw their funds and then send money back in again. 
        // Still coming up with a solution to this. 
        if (shares[msg.sender] == 0 && shareholders.length < MAX_SHAREHOLDERS) {
            shareholders.push(msg.sender);
        }
        // Add the sent payment to an existing balance 
        shares[msg.sender] = shares[msg.sender] + msg.value;
    }

    // All smart contracts should have a selfdestruct kill switch
    function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    // We require that the msg sender is the owner, and check to make sure
    // we are below our max shareholder threshold before attempting to add them
    // We also initialize a shareholder with 1 Wei so that when they send money their address isn't duplicated. 
    // Also, not sure why only the owner can set shareholders if anyone can send money to the contract. 
    // Requirements and definitions definitely need to be fleshed out with the customer before development continues.
    function addAddress(address _addr) {
        require(msg.sender == owner);
        if (shareholders.length < MAX_SHAREHOLDERS) {
            shareholders.push(_addr);
            shares[_addr] = 1;
        } else {
            FailedAddShareholder("MAX_SHAREHOLDERS");
        }
    }
    // Removed the re-entrancy attack in withdraw. 
    function withdraw() {
        if (shares[msg.sender] > 0) {
            uint sh = shares[msg.sender];
            shares[msg.sender] = 0;
            msg.sender.send(sh);
        } else {
            FailedSend(msg.sender, shares[msg.sender]);
        }
    }

    // By implementing a shareholder threshold, we can keep the code below.
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

    // Added some getters for pertinent information not available in the original contract
    // These were immensely helpful when building the React.js interface
    function getLength() constant returns (uint) {
        return shareholders.length;
    }

    function getAddresses() external returns (address[]) {
        return shareholders;
    }

    function getShares(address _addr) external returns (uint) {
        return shares[_addr];
    }

}
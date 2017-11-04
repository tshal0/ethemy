var Ethemy = artifacts.require("./Ethemy.sol");
module.exports = function(deployer) {
  deployer.deploy(Ethemy, {gas: 1000000});
};
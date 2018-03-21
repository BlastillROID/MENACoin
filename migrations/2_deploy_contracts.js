

var MENACOIN = artifacts.require("./MENACOIN/MENA.sol")

module.exports = function(deployer) {

  deployer.deploy(MENACOIN,"MENATEST","MNT",8,100000);
};
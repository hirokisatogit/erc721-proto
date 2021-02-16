const erc1155certificate = artifacts.require('./ERC1155Certificate.sol');

module.exports = function (deployer) { 
  deployer.deploy(erc1155certificate);
};

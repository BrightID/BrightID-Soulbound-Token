const BrightIDSoulboundSingleMintAutoId = artifacts.require("BrightIDSoulboundSingleMintAutoId");

module.exports = function (deployer) {
  deployer.deploy(BrightIDSoulboundSingleMintAutoId, "0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x736f756c626f756e640000000000000000000000000000000000000000000000", "mrplustest", "MPT");
};

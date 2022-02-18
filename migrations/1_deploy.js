const BrightIDSoulbound = artifacts.require("BrightIDSoulbound");

module.exports = function (deployer) {
  deployer.deploy(BrightIDSoulbound, "0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x0000000000000000000000000000000000000000000000000000000000000000", "mrplustest", "MPT");
};

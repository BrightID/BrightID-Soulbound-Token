// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../BrightIDValidatorBase.sol";

contract BrightIDValidatorMulti is BrightIDValidatorBase {
    IERC20 private _verifierToken;

    constructor(IERC20 verifierToken_, bytes32 context_) BrightIDValidatorBase(context_) {
        _verifierToken = verifierToken_;
    }

    /**
     * @dev Set `_verifierToken` to `verifierToken_`.
     *
     * Requirements:
     *
     * - the caller must be the owner.
     */
    function setVerifierToken(IERC20 verifierToken_) external virtual onlyOwner {
        _verifierToken = verifierToken_;
    }

    /**
     * @dev Returns the verifier token address of the BrightID validator.
     */
    function verifierToken() public view virtual returns (IERC20) {
        return _verifierToken;
    }

    /**
     * @dev See {IBrightIDValidator-isTrustedValidator}.
     */
    function isTrustedValidator(address signer) public view virtual returns (bool) {
        return _verifierToken.balanceOf(signer) > 0;
    }
}

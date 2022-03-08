// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./../validator/BrightIDValidatorSingle.sol";

/**
 * @dev Signature based implementation of {BrightIDValidatorSingle}.
 */
contract BrightIDValidatorSignature is BrightIDValidatorSingle {
    using ECDSA for bytes32;
    using ECDSA for bytes;

    bytes private _messageToSign;
    bytes32 private _messageHash;

    constructor(
        address verifier_,
        bytes32 context_,
        bytes memory messageToSign_
    ) BrightIDValidatorSingle(verifier_, context_) {
        _messageToSign = messageToSign_;
        _messageHash = messageToSign_.toEthSignedMessageHash();
    }

    /**
     * @dev Returns the message to be signed.
     */
    function messageToSign() public view virtual returns (string memory) {
        return string(_messageToSign);
    }

    /**
     * @dev Validate signed BrightID verification data.
     *
     * Requirements:
     *
     * - signer of signature must be a trusted validator.
     */
    function _validate(
        bytes calldata contextIds,
        uint256 timestamp,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal view virtual {
        bytes32 message = keccak256(abi.encodePacked(context(), contextIds, timestamp));
        address signer = message.recover(v, r, s);
        require(isTrustedValidator(signer), "BrightIDValidatorSignature: Signer not authorized");
    }

    function _recoverAll(bytes calldata contextIds) internal view virtual returns (address[] memory) {
        uint256 length = contextIds.length / 65;
        address[] memory members = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            members[i] = _messageHash.recover(contextIds[i * 65:(i + 1) * 65]);
        }
        return members;
    }

    function _recoverAt(bytes calldata contextIds, uint256 index) internal view virtual returns (address) {
        return _messageHash.recover(contextIds[index * 65:(index + 1) * 65]);
    }
}

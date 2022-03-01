// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./../BrightIDValidatorBase.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @dev UUID based implementation of {BrightIDValidatorBase}.
 */
contract BrightIDValidatorOwnership is BrightIDValidatorBase {
    using ECDSA for bytes32;

    /**
     * @dev Emitted when `addr` is bound.
     */
    event AddressBound(address indexed addr);

    // Mapping keccak(UUID) to address
    mapping(bytes32 => address) internal _uuidToAddress;

    constructor(address verifier, bytes32 context) BrightIDValidatorBase(verifier, context) {}

    /**
     * @dev Bind an UUID to an address.
     * This function is currently unsafe because an attacker may
     * bind a compromised address to a context id linked to their BrightID.
     * See {BrightIDSoulboundSingleMintAutoId-bind} for a temporary fix.
     *
     * Requirements:
     *
     * - `uuidHash` must be not bound.
     * - `signature` must be a valid ETH signed signature.
     * - the signer of `signature` must be `owner`.
     *
     * @param owner Owner address of signature
     * @param uuidHash Keccak hash of generated UUID
     * @param nonce Generated nonce
     * @param signature Signed packed data
     */
    function bind(
        address owner,
        bytes32 uuidHash,
        uint256 nonce,
        bytes calldata signature
    ) public virtual {
        require(_uuidToAddress[uuidHash] == address(0), "BrightIDValidatorOwnership: UUID already bound");
        address signer = getUUIDHash(owner, uuidHash, nonce).toEthSignedMessageHash().recover(signature);
        require(signer != address(0) && signer == owner, "BrightIDValidatorOwnership: Signature invalid");
        _uuidToAddress[uuidHash] = owner;
        emit AddressBound(owner);
    }

    /**
     * @dev Returns a hashed UUID
     *
     * @param uuid Hex encoded generated UUID
     */
    function hashUUID(bytes32 uuid) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(uuid));
    }

    /**
     * @dev Constructs and returns a hash used by this registry implementation.
     *
     * @param owner Owner address of signature
     * @param uuidHash Keccak hash of generated UUID
     * @param nonce Generated nonce
     */
    function getUUIDHash(
        address owner,
        bytes32 uuidHash,
        uint256 nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(owner, uuidHash, nonce));
    }
}

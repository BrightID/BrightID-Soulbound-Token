// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Counters.sol";
import "../extensions/BrightIDSoulboundEnumerable.sol";

contract BrightIDSoulboundSingleMintAutoId is BrightIDSoulboundEnumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    constructor(
        address verifier,
        bytes32 context,
        string memory name_,
        string memory symbol_
    ) BrightIDSoulbound(verifier, context, name_, symbol_) {}

    /**
     * @dev Creates a new token for the address bound to the newest context id.
     *
     * See {BrightIDSoulbound-_mint}.
     *
     * Requirements:
     *
     * - the token balance of all contextIds associated with the caller BrightID must be zero.
     */
    function mint(
        bytes32[] calldata contextIds,
        uint256 timestamp,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        _validate(contextIds, timestamp, v, r, s);
        uint256 balance;
        for (uint256 i = 0; i < contextIds.length; i++) {
            balance += BrightIDSoulbound.balanceOf(_uuidToAddress[hashUUID(contextIds[i])]);
        }
        require(balance == 0, "BrightIDSoulboundSingleMintAutoId: This BrightID had minted");
        require(
            _uuidToAddress[hashUUID(contextIds[0])] != address(0),
            "BrightIDSoulboundSingleMintAutoId: UUID not bound"
        );
        _safeMint(_uuidToAddress[hashUUID(contextIds[0])], _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }
}

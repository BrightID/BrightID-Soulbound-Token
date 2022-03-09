// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../BrightIDSoulbound.sol";

contract BrightIDSoulboundCelebration is BrightIDSoulbound, ReentrancyGuard {
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
    ) external nonReentrant {
        require(_tokenIdTracker.current() < 10000, "BrightIDSoulboundCelebration: Limit reached");
        _validate(contextIds, timestamp, v, r, s);
        uint256 balance;
        for (uint256 i = 0; i < contextIds.length; i++) {
            balance += BrightIDSoulbound.balanceOf(_uuidToAddress[hashUUID(contextIds[i])]);
        }
        require(balance == 0, "BrightIDSoulboundCelebration: This BrightID had minted");
        _safeMint(_uuidToAddress[hashUUID(contextIds[0])], _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }

    /**
     * @dev See {BrightIDValidatorOwnership-bind}.
     * A temporary safe version of {BrightIDValidatorOwnership-bind},
     * it fixes the issue by preventing binding to an address that currently owns a token.
     */
    function bind(
        address owner,
        bytes32 uuidHash,
        uint256 nonce,
        bytes calldata signature
    ) public override {
        super.bind(owner, uuidHash, nonce, signature);
        require(balanceOf(owner) == 0, "BrightIDSoulboundCelebration: Address currently in use");
    }

    function totalSupply() public view virtual returns (uint256) {
        return _tokenIdTracker.current();
    }

    function tokenURI(uint256) public pure override returns (string memory) {
        return "ipfs://QmcFUUnGkURUi1Q97pDvmUaG8QwcdzqzqUm6oxxikWbkyE/1.json";
    }
}

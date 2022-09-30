## BrightID-Soulbound-Token

A proof of concept inspired by Vitalik Buterin's article titled [Soulbound](https://vitalik.eth.limo/general/2022/01/26/soulbound.html) and a forum post by Triplespeeder titled [Implementing Soulbound NFTs with BrightID](https://forum.brightid.org/t/implementing-soulbound-nfts-with-brightid/430).

Note that this is only a PROOF OF CONCEPT, security issues not related to BrightID and its verification system may not be taken into consideration.

## Features

- Uses BrightID to verify unique humans.
- Regular token transfers are disallowed.
- Special token transfers called "rescues" are allowed when the BrightID owner can provide proof that the token owner wallet belonged to them.

## Standard Presets

- Single Mint Auto Id
  - Only allow a maximum balance of one among all addresses associated with the same BrightID
  - Token ids are generated using a counter

## Registry Extensions

- UUID ownership based implementation
  - Requires more steps for validation
  - UUID ownership proved with ETH signature

## Note

- All token contracts should be compatible with sites that support ERC-721, though the contract themselves do not actually implement all methods in ERC-721, due to the removal of the approval mechanic used by regular ERC-721 contracts. This was done to save gas on contract deployment as no unnecessary persistent storage would be wasted. Also the deployed bytecode size should be smaller thanks to the removal of functions instead of empty implementations.

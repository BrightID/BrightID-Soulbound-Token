## BrightID-Soulbound

A proof of concept inspired by Vitalik Buterin's article titled [Soulbound](https://vitalik.eth.limo/general/2022/01/26/soulbound.html) and a forum post by Triplespeeder titled [Implementing Soulbound NFTs with BrightID](https://forum.brightid.org/t/implementing-soulbound-nfts-with-brightid/430).

Note that this is only a PROOF OF CONCEPT, security issues not related to BrightID and it's verification system are not taken into consideration.

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

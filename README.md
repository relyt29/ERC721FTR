# ERC721FTR

ERC721 Fuck the Rich: An NFT implementation that refuses to be traded, sent, minted or received by anyone who has more than a `THRESHOLD` amount of WETH or ETH.

You can use this by creating a contract that inherits from ERC721FTR.


Truly, a revolution in democracy for NFTs.


_Note: please don't actually use this code for anything._ It has not been extensively tested, and is mostly just an elaborate joke. I hope someone else finds this as amusing as I did.

Thank you to the solmate team, and the foundry team for the ERC721 template, and the build system.

# Build and Test

The repo expects a [Foundry](https://github.com/foundry-rs/foundry/tree/master/forge) build system. You should check the WETH address in ERC721.sol to point to whatever chain you're interested in (mainnet, rinkeby, etc). Then you can run the test suite with:

```bash
forge test --fork-url "rpc_for_chain" -vvvvv
```

You need to point the test system at some RPC provider, or mock your own WETH implementation for testing, because otherwise you'll get weird revert errors when the ERC721FTR contract can't find the WETH contract to check people's WETH balances.

# Author

Relyt29. [Follow me on twitter](https://twitter.com/relyt29)

# License

WTFPL, except stuff attached to solmate, which is AGPL.

# Lecture 6 Notes
This lecture is about writing a complete application (Dapp) with a little front-end.
The example shows how to implement a simple oracle. The oracle used here is to provide the exchange rate between ADA/USD.

The oracle source is represented as a UTxO that sits at the script address of the oracle. The datum field provides the current value of the oracle provided data. A NFT is used to authenticate the true oracle UTxO.

A use case for the oracle is swap contract where at the swap address someone can deposit ADA and someone else can deposit USD stablecoin to get that ADA. The oracle value data is used to determine the exchange rate. The oracle provided attaches a fee to use its value is used in a Tx.
The oracle should be capable of working contracts other than the swap (which is just one use case).
The oracle UTxO must be an input to the Tx so the swap validator has access to it.

There should be an oracle validation logic to check that the NFT is present and that there is an output at the oracle address containing the NFT. It should support two operations ("use" and "update")
For the "use" redeemer, it should also check that a fee was paid.
After the oracle validation logic the swap logic can actually take place.
The swap validator ensures that the buyers pays the correct price to the seller.
For the "update" redeemer, it should also allow the data provided to be updated if the tx is signed by the oracle provider and can also retrieve the fee paid by users of its service.

## Plutus Application Backend (PAB)
It allows us to turn everything written into an application. If there was Testnet or if Plutus was available on the mainnet already we could deploy it on the testnet but now we have to use a simulated blockchain. The process of turning it into a DApp will be the same when plutus is launched on the testnet.
It contains just one type definition, the idea is that it reifies of the contract instances we want to run.

# Things to lookup
* Understand what `Constraints` is in the off-chain part.
* Haskell monoid
* `tell`
* Write http clients to do POST/GET request

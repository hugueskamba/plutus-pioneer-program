# Lecture 5 Notes
This lecture is about minting policy for native tokens.

Each asset class (native token) is identified by the currency symbol and a token name.

## Values
A value says how many unit of each asset class are contained in it.
### Ada
```
> import Plutus.V1.Ledger.Ada
> :set -XOverloadedStrings
> adaSymbol

> adaToken
""
> lovelaceValueOf 123
Value (Map [(, Map [("", 123)])])
> lovelaceValueOf 123 <> lovelaceValueOf 10
Value (Map [(,Map [("",133)])])
```
## Create native tokens
You use the `singleton` function to create native tokens.
```
singleton [HEXADECIMAL_STRING_CURRENCY_SYMBOL] [STRING_TOKEN_NAME] [UNITS]
> singleton "a8ff" "ABC" 7
Value (Map [(a8ff, Map [("ABC",133)])])
> let v = singleton "a8ff" "ABC" 7 <> lovelaceValueOf 42 <> singleton "a8ff" "XYZ" 100
Value (
    Map[
        (, Map [("",42)]),
        (
            a8ff, Map [
                ("ABC",7), ("XYZ", 100)
            ]
        )
    ]
)]
> valueOf v "a8ff" "XYZ"
100
> flattenValue v
[(a8ff, "ABC", 7), (a8ff, "XYZ", 100), (, "", 42)]
```
A CurrencySymbol is the hash of the mint policy script.
Since a Tx cannot create or burn a token, a minting policy script is needed to do that.
The CurrencySymbol is the hash of the minting policy script for a given token. The corresponding script is included in the Tx and it is executed along with the validation script. Ada is special because it has no script to generate it and therefore its CurrencySymbol is an empty value, all the Ada that exist come from the genesis block/transaction which set a fixed total number of Ada.

## Minting policy script
Unlike the validation script which gets a reedemer, datum and context (datum belongs to UTxO, and the reedemer belongs to the input); the minting policy script only gets the context.

### Off-chain
`val`: represents the value we want to construct
`lookups`: provides an indication where to find the minting policy script to run and params
`tx`: defines what we want to do in the transaction
`ledgerTx` is the handle to the transaction constructed/submitted.
The Plutus libraries automatically try to construct a transaction from the constraints provided in the off-chain contract if possible.
`endpoints`: the name of the contract that the Plutus playground will run.

Use `runEmulatorTraceIO` for a faster development cycle without having to run the Plutus Playground.

## Non-Fungible-Token
Tokens that can only exist once, there is only one instance of the token.
This can be achieved by:
1. using deadlines where coins cannot be minted after the deadline has passed. However, a blockchain explorer is needed to check that only one was been minted. They are not true NFTs in the sense that the currency symbol by itself does not guaranty uniqueness.
2. using Plutus, prevent that there is not more than one minting transaction. The policy script only results true for one transaction. This can be done by using something unique in the script. The ETUxO ID can be used because it can only exist once, so it can be used.

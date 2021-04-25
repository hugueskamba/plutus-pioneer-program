# Lecture 3 Notes

## Plutus changes
Plutus has been updated to change the type used for context to `ScriptContext` and the validator hash is no longer necessary to generate the script address.
It is also no longer necessary to remove the include remove the module header (`module Week03.IsData where`) when copying the script to the playground.
Fees (10 lovelace) are now considered in the playground but they are not yet realistics. The fees in the future will be dependent on the memory consumption and the execution time (the time it takes to execute the validator). Therefore we should use a value greater than 10 lovelace as the initial UTxO.

## Subject

The lecture is going to focus on the context.

## Intro
One of the biggest advantage of Cardano is that it has deterministic validation as validation happens in the wallet before the script is ran on the network thus avoiding the case where a transaction sent to the network ends up failing. However, validating certain time critical transactions on the wallet can be difficult as they are dependent on time. Therefore time needs to be simulated for wallet validation, this is done with `ScriptContext.ScriptContextTxInfo.txInfoValidRange` which is a time interval (defined in `plutus/plutus-ledger-api/src/Plutus/V1/Ledger/Contexts.hs`).

We will be implementing a vesting script using the context.

## Implementation

To get access to Wallet 2 public key hash run, the following command in `cabal repl`:
```
pubKeyHash $ walletPubKey $ Wallet 2
```

The script address will be the same if the same validator is used regardless of who initiates the transaction as they will get the same compiled Plutus script code.

A parameterised script is like a family of scripts. You can instantiate it with a different parameters and you get different scripts. When parameterised scripts are used the script adresses are different because the parameters are compiled into the script and therefore also into the script hash. Whether it is a good thing or bad thing it depends on the use case. The Datum and Redeemer are now trivial and the grab endpoint is easier to implement because we do not need to filter anymore but the deadline needs to be added to the grab endpoint.

The Lift class allows us at runtime to lift Haskell values to corresponding Plutus script values.


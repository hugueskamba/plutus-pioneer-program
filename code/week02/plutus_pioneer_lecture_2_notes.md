# Lecture 2 Notes

There 3 pieces of data that a plutus validator script gets: the datum, the redeemer, and the context (consisting of tx being validated with its i/o). They have to be represented by a Haskell data type. They use the same data type in Haskell `Data` (defined in `plutus/plutus-tx/src/PlutusTx/Data.hs`).

Boiler plate for Plutus contract
```haskell
{-# INLINABLE mkValidator #-}
mkValidator :: Data -> Data -> Data -> ()
mkValidator _ _ _ = ()

validator :: Validator
validator = mkValidatorScript $$(PlutusTx.compile [|| mkValidator ||])

scrAddress :: Ledger.Address
scrAddress = scriptAddress validator
```

`mkValidator` can throw an error if run into an error during validation. However the `Gifts` example always succeeds. It needs to be compiled to be turned into a Plutus script using using template Haskell (`$$()`) which is similar to macros in C++. It gets expanded at compile time.

Inlinable functions are usually meant to be used in validation scripts as they are created so they can be used in template Haskell which requires functions to be inlined.

The Plutus script is hashed and that defines the address that is used.

`Prelude` is the Haskell module included by default and contains many usuful data types, combinators and functions. However, they cannot be used in Plutus validator because they are not inlinable. Alternatives (`PlutusTx.Prelude`) to those are therefore provided. `{-# LANGUAGE NoImplicitPrelude   #-}` prevents the default `Prelude` to be included.

To be more type safe, it is better to not use the `Data` type for the datum, redeemer and context. The data type `ScriptContext` is always to be used for the context and `Bool` to indicate success or error.

```haskell
-- Tell the compiler which type picked for datum and redeemer
data Typed
instance Scripts.ScriptType Typed where
    type instance DatumType Typed = ()
    type instance RedeemerType Typed = Integer

-- compile
inst :: Scripts.ScriptInstance Typed
inst = Scripts.validator @Typed
    $$(PlutusTx.compile [|| mkValidator ||])
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = Scripts.wrapValidator @() @Integer
```


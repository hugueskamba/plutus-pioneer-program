# Lecture 4 Notes
This lecture is about the off-chain part of a Plutus script. Plutus provides version s of traditional Haskell libraries with the inline pragma as it is needed for the template Haskell to compile it into Plutus script.
The off-chain part does not get compiled into a Plutus script. It is just Haskell. However, it uses much more sofisticated Haskell features. For example they use Monads which are hard to explain.

## IO action 
`IO` action is a recipe that produces a side-effect. In `IO ()`, it is a recipe that returns a unit.
Example:
```haskell
main :: IO ()
main = putStrLn "Hello, world!"
-- :t putStrLn => putStrLn :: String -> IO ()
-- :t getLine => getLine :: IO St  ring
```

## The Functor typeclass
```haskell
`fmap` takes a function from one type to another and a functor applied with one type and returns a functor applied with another type.
class Functor f where
	fmap :: (a -> b) -> f a  -> f b
```

## The sequence operator (`>>`)
`>>` it chains two IO actions together
```haskell
putStrLnb "Hello" >> putStrLn "World"
```

## The bind operator (`>>=`)
```haskell
:t (>>=)
Monad m => m a -> (a -> m b) ->  m b -- If I have a recipe that performs side effects and returns an a and if I have a function that given an a gives me a recipe than gives me a b then these two can combine to a recipe that returns a b.
getLine >>= putStrLn -- it's something like piping
```

## The `return` function
```haskell
:t return
return :: Monad m => a -> m a -- Given an a, it can produce a recipe that can contain side-effects.
return "Haskell" :: IO String
```

## Monad
It's a concept of computation with some additional side effects (real world, failure, failure with error messages, producing log out) and the possibility to bind two such computations together.

Implement `return` and `>>=` to implement a Monad.
For `Functor` instance use `liftM`.
For `Applicative` instance use `ap`.

It is useful to describe a pattern a give it a name. It is also useful for code reusability and simplifying code.

Read about:
* lambda
* case in Haskell
* Maybe typeclass
* Either typeclass
* Monads
* `do` notation
* Monoid

There is contract monad which defines off-chain code that will be running in the wallet.
```haskell
-- Contract w s e a 
-- w: it allows you to write log message of type w
-- s: the capabiility of the blockchain, what blockchain specific actions this contract can perform (i.e waiting for a slot, submit tx, finding out public key)
-- e: defines the type of error messages
-- a: result of the computation
```
One of the main purpose of the Contract monad is to construct and submit transactions.

## Do notation
It is syntactic sugar for Monads when the bind operation is used `(>>=)` that allow you to use `<-`.

## `endpoint` function
The `endpoint` function is a contract that blocks until an input is provided from the outside.
```haskell
give :: (HasBlockchainActions s, AsContractError e) => Integer -> Contract w s e ()
...
endpoints :: Contract () GiftSchema Text ()
endpoints = (give' `select` grab') >> endpoints -- Recursively call itself
  where
    give' = endpoint @"give" >>= give -- Blocks until params (Integer in this case) are provided and then passed to the give function
    grab' = endpoint @"grab" >>= grab
```
# Lecture 9 Notes
This lesson is about Marlowe, a domain specific language for financial contracts.
It was designed for users as well as developers. It is written to be closer to the language of the user. A contract is just a program running on a blockchain. Designed for maximum assurance.

## Safety properties of Marlowe

* Contracts are fine (no recursion or loops).
* Contracts will terminate (timeouts on actions).
* Contract will have a defined lifetime (read off from timeouts).
* No assets retained on close (accounts refunded on close).
* Conservation of value (from the underlying blockchain)

These guaranteed for Plutus contracts

## The Marlowe language overview

It it represented as a Haskell data type.
```haskell
data Contract = Close
                | Pay Party Payee Value Contract
                | If Observation Contract Contract
                | When [Case Action Contract] Timeout Contract
                | Let ValuedId Value Contract
                | Assert Observation Contract
```
Marlowe is a suite that is made of:
* Marlowe Run: a system through which an end-user interact with contracts running on the Cardano blockchain. It is akin to a DApp.
* Marlowe Market: where contracts can be uploaded, downloaded and assurances can be given about these contracts.
* Marlowe Play: where contracts can be simulated interactively.
* Marlowe Build: where contracts can be built in various different ways.

Marlowe play and Build are bundled under the `Marlowe Playground` which is already available (UI and UX re-design is under development). A prototype of Marlowe Run will be released shortly. Requires the Plutus application back-end to be avalaible on Cardano.

A Cardano node on which Plutus (a dialect of Haskell) is running, Marlowe is embedded in Haskell and is executed using Plutus and is linked to wallets (through Marlowe Run) and data oracles in the real world.

Executing a Marlowe contract will produce a series of transactions on the blockchain. What Plutus is running on Cardano checks the validity of transactions, the validation function for the Marlowe transactions are Marlowe interpreter. It checks that the transactions conforms to the steps of executing a Marlowe contract (using the EUTxO model). On-chain, we pass the current state of the contract and other information through as datum. The Marlowe interpreter uses that to ckeck that the transactions submitted meet the criteria for the particular Marlowe contract. Off-chain, we have to have Marlowe Run, build the Txs that meet the validation step on-chain and if and when the contract requires crypto assets we will have off-chain to ensure that Txs are appropriately signed to have authorization for spending crypto assets.

### Marlowe Run
To interact with a contract a wallet needs to be involved to control signature and asset. It is an intuitive interface to have contracts running on the blockchain where each participant of the contract get their view of the contract in real time.
It submits transactions to the blockchain that then can be checked, validated by the Marlowe interpreter which is itself a large Plutus contract.


## How to write Marlowe
Marlowe contracts can be written in a number of ways:
* Using the Marlowe language
* Using the visual editor (scratch type blocks)
* Haskell or Jasvascript description of Marlowe contracts
* Contract generator on the basis of some of the contract terms

### Marlowe Playground
https://play.marlowe-finance.io
It allows simulation of contracts. Currently undergoing a UI/UX revamp.

### More information about Marlowe
* The Marlowe and plutus GitHub repos.
* The IOHK research library: search for "Marlowe".
* Online tutorial in the Marlowe Playground.

## Marlowe in Plutus


To learn:
* Play with https://alpha.marlowe.iohkdev.io
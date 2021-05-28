# Lecture 7 Notes
This lesson is about state machines.

A state machine is a system which start in a certain state and there are transitions to other states.
In a Blockchain, a state machine is represented by a UTxO sitting at the state machine script address.
The state of the state machine is the Datum of the UTxO. The transition is the transaction that consumes the current UTxO using the Redeemer that characterises that transition and produces a new UTxO at the same address where the Datum now reflects the new state.
There is support in the Plutus library to implement such state machine.
State Machine allow to write less code to express the logic of a smart contract. This is because there is a lot of code sharing due to use of Constraints and boilerplate are contained in the state machine.
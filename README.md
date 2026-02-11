# Permissioned Token Whitelist

A sophisticated smart contract framework for managing regulated or restricted digital assets. This project extends the standard ERC-20 functionality by adding an administrative layer that validates the sender and receiver of every transaction against an authorized whitelist.

## Features
* **Compliance Ready:** Ideal for security tokens or projects requiring KYC/AML verification.
* **Role-Based Access:** Uses OpenZeppelin's `AccessControl` for granular management of whitelist admins.
* **Emergency Pause:** Includes a circuit breaker to halt all transfers in case of a security breach.
* **Zero Subfolders:** All logic is contained in the root directory for maximum accessibility.

## Implementation Details
The contract overrides the `_update` function (internal to OpenZeppelin ERC20 v5.0+) to inject a validation check. If either the sender or the recipient is not on the whitelist, the transaction is reverted.

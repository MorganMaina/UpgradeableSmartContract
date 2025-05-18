# UpgradeableSmartContract

## 🔍 Overview

This project demonstrates a minimal implementation of a smart contract proxy pattern following the [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967) standard. It separates contract logic from storage and enables upgradeability of the logic contract while preserving state.

## 🛠 Proxy Standard: EIP-1967

EIP-1967 is a proxy standard that defines fixed storage slots to avoid collisions between proxy and implementation contracts. It simplifies upgradeable contract design and avoids the complexities of earlier patterns like unstructured storage.

### 🔧 Key Concepts

- **Proxy Contract**:
  Acts as a forwarder using `delegatecall` to forward calls to the implementation logic.
- **Implementation Slot**:
  Fixed at:  
  `bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)`  
  →  
  `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
- **Upgradeability**:
  Only the admin can change the implementation address, ensuring controlled upgrades.

## 📄 Files

### ✅ Proxy.sol

- Handles storage of implementation address.
- Uses inline assembly for reading/writing the implementation slot.
- Includes:
  - `fallback()` for delegate calls.
  - `receive()` to accept Ether.
  - `upgradeTo()` for admin-only upgrades.
  - `getImplementation()` for viewing the logic address.

### ✅ Logic.sol

A simple contract with `setNumber()` and `getNumber()` to test upgradeability via the proxy.

## 🧪 Testing the Proxy (Using Remix)

1. Deploy `Logic.sol`.
2. Deploy `Proxy.sol` with the address of Logic as constructor argument.
3. Interact with the proxy:
   - Use the ABI of Logic.sol and connect it to the Proxy address.
   - Call `setNumber(42)` and check `getNumber()` returns `42`.
4. Deploy a new version of Logic with different logic and upgrade using `upgradeTo()`.

## 🔐 Security Considerations

- Only the admin (constructor-defined) can upgrade the implementation.
- `delegatecall` passes on the context and must be used with caution.
- This is a simplified version; for production, consider using [OpenZeppelin Upgrades](https://docs.openzeppelin.com/upgrades/2.3/).

## 📚 Resources

- [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967)
- [Solidity Docs](https://docs.soliditylang.org)
- [OpenZeppelin Upgrades](https://docs.openzeppelin.com/upgrades)

---

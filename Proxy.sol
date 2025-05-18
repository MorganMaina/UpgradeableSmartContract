// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Minimal Upgradeable Proxy (EIP-1967)
/// @notice Implements a simple proxy pattern with upgradeability following EIP-1967 standard
contract Proxy {
    // Address of the admin (can upgrade implementation)
    address private immutable admin;

    // Constructor sets initial implementation and admin
    constructor(address _implementation) {
        admin = msg.sender;

        // Store implementation address at the EIP-1967 slot
        assembly {
            // EIP-1967 implementation slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
            let slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            sstore(slot, _implementation)
        }
    }

    /// @notice Fallback function delegates calls to current implementation
    fallback() external payable {
        assembly {
            let slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            let impl := sload(slot)
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    /// @notice Receive function to accept plain Ether
    receive() external payable {}

    /// @notice Admin function to upgrade implementation address
    function upgradeTo(address newImplementation) external {
        require(msg.sender == admin, "Only admin can upgrade");
        assembly {
            let slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            sstore(slot, newImplementation)
        }
    }

    /// @notice View the current implementation address
    function getImplementation() external view returns (address impl) {
        assembly {
            let slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            impl := sload(slot)
        }
    }
}

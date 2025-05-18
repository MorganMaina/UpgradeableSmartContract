// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

///  Logic Contract
/// Contains actual logic to be used behind proxy
contract Logic {
    uint256 public number;

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }
}

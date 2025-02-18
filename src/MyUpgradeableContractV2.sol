// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyUpgradeableContract.sol";

contract MyUpgradeableContractV2 is MyUpgradeableContract {
    /// @dev New function in V2
    function decrement() external {
        number--;
    }
}

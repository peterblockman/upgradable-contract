// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import from OpenZeppelin upgradeable libraries
// use relative path to locate the contracts
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract MyUpgradeableContract is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // Example state variable
    uint256 public number;

    /// @dev Replaces constructor for upgradeable contracts.
    ///      "initializer" ensures it can only be called once.
    function initialize(uint256 _num) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        number = _num;
    }

    /// @dev Required by UUPS to authorize upgrades.
    ///      Restrict to owner only.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    /// @dev Example function: increments 'number'.
    function increment() external {
        number++;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "../src/MyUpgradeableContract.sol";
import {console} from "forge-std/Test.sol";

contract DeployUpgradeable is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the implementation
        MyUpgradeableContract impl = new MyUpgradeableContract();
        console.log("Contract V1 deployed at:", address(impl));
        // Encode the initializer function call (e.g., initialize(42))
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 42);

        // Deploy the proxy (admin address is set to msg.sender for this example)
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(impl), msg.sender, data);

        console.log("Proxy deployed at:", address(proxy));

        vm.stopBroadcast();
    }
}

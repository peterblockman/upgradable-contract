// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

// Import your new V2 contract
import "../src/MyUpgradeableContractV2.sol";

// Import the UUPSUpgradeable interface (or base) so we can cast the proxy
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title UpgradeToV2
 * @dev A Foundry script that upgrades a UUPS proxy to MyUpgradeableContractV2.
 */
contract UpgradeToV2 is Script {
    /**
     * @dev Replace these with actual addresses from your deployment:
     *      - proxyAddress: The address of the already deployed ERC1967Proxy (pointing to V1).
     */
    address internal constant PROXY_ADDRESS = 0x712516e61C8B383dF4A63CFe83d7701Bce54B03e;

    function run() external {
        /**
         * Start broadcasting transactions with the private key specified
         * on the CLI via `--private-key` or in your foundry.toml.
         * This MUST be the owner of the proxy in a UUPS setup.
         */
        vm.startBroadcast();

        // 1. Deploy new V2 implementation
        MyUpgradeableContractV2 newImplementation = new MyUpgradeableContractV2();
        console.log("Deployed new V2 implementation at:", address(newImplementation));

        // 2. Upgrade the proxy to V2.
        //    In OZ 5.x, there's only `upgradeToAndCall`, so we pass an empty data param if no extra call is needed.
        UUPSUpgradeable(PROXY_ADDRESS).upgradeToAndCall(
            address(newImplementation),
            bytes("") // empty data means no extra call
        );

        console.log(
            "Upgraded proxy at", PROXY_ADDRESS, "to new implementation (contract V2):", address(newImplementation)
        );

        // 3. Test the new V2 function
        // Query the number from the proxy
        console.log("Number from proxy:", MyUpgradeableContractV2(PROXY_ADDRESS).number());

        // Call the new V2 function
        MyUpgradeableContractV2(PROXY_ADDRESS).decrement();
        console.log("Decremented number to:", MyUpgradeableContractV2(PROXY_ADDRESS).number());

        vm.stopBroadcast();
    }
}

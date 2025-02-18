// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

// We'll use OpenZeppelin's ERC1967Proxy (UUPS-compatible) for a quick test proxy
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../src/MyUpgradeableContract.sol";
import "../src/MyUpgradeableContractV2.sol";

contract MyUpgradeableContractTest is Test {
    MyUpgradeableContract public v1;
    MyUpgradeableContractV2 public v2;
    ERC1967Proxy public proxy;

    MyUpgradeableContract public proxyAsV1;
    MyUpgradeableContractV2 public proxyAsV2;

    function setUp() public {
        // 1. Deploy the V1 implementation
        v1 = new MyUpgradeableContract();

        // 2. Encode the initializer call
        bytes memory data = abi.encodeWithSelector(MyUpgradeableContract.initialize.selector, 42);

        // 3. Deploy a UUPS proxy pointing to V1, calling initialize(42)
        proxy = new ERC1967Proxy(address(v1), data);

        // 4. Wrap the proxy address in the V1 ABI
        //    So we can call increment() etc.
        proxyAsV1 = MyUpgradeableContract(address(proxy));
    }

    function testInitialValue() public view {
        // The initialize(42) should set number=42
        uint256 val = proxyAsV1.number();
        assertEq(val, 42, "Should have initialized with 42");
    }

    function testIncrementOnV1() public {
        proxyAsV1.increment();
        assertEq(proxyAsV1.number(), 43, "Should have incremented to 43");
    }

    function testUpgradeToV2() public {
        // Deploy the new implementation (V2)
        v2 = new MyUpgradeableContractV2();

        // Upgrade via the proxy (as the owner)
        // The proxyAsV1 has an "upgradeTo" function inherited from UUPSUpgradeable
        // But we must do it as an owner. We'll cheat in tests by simply impersonating.
        vm.prank(proxyAsV1.owner());
        proxyAsV1.upgradeToAndCall(address(v2), bytes(""));

        // Now the proxy's logic is V2, so we wrap it in a V2 ABI
        proxyAsV2 = MyUpgradeableContractV2(address(proxy));

        // Confirm old state is still there
        assertEq(proxyAsV2.number(), 42, "Should still be 42 after upgrade");

        // Test a function from the old version
        proxyAsV2.increment();
        assertEq(proxyAsV2.number(), 43, "Should increment to 43");

        // Test the new V2 function
        proxyAsV2.decrement();
        assertEq(proxyAsV2.number(), 42, "Should decrement back to 42");
    }
}

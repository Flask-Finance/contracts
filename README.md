# StakingContract.sol
constructor(address _tokenContractAddress): Initializes the contract by setting the address of the TokenContract.
stake(uint256 amount): Allows users to stake a specified amount of tokens. The tokens are transferred from the user to the contract, and the user's balance and the total staked amount are updated. The staking timestamp is recorded.
unstake(): Allows users to unstake their tokens if the lock-up period has ended. The tokens are transferred back to the user, and the user's balance and the total staked amount are adjusted accordingly.
claimRewards(): Allows users to claim their staking rewards if there are any available. The rewards are transferred to the user, and the user's staking rewards are updated.
calculateRewards(address user): Calculates the rewards for a specific user based on their staked amount and the staking duration. It applies a time-based factor to the rewards based on the proportion of the lock-up period that has passed.
isLockUpPeriodFinished(address user): Checks if the lock-up period has passed for a specific user. It compares the current timestamp with the staking timestamp and returns true if the lock-up period has ended, and false otherwise.
updateTokenContract(address _tokenContractAddress): Allows the contract owner to update the address of the TokenContract.
withdrawTokens(address to, uint256 amount): Allows the contract owner to withdraw excess tokens from the staking contract. Tokens are transferred to the specified recipient address.
In terms of the lock-up period, it is defined as a constant value (lockUpPeriod) of 30 days in the provided code. The isLockUpPeriodFinished function compares the difference between the current timestamp and the staking timestamp to determine if the lock-up period has passed for a specific user. This check is used in the unstake function to ensure users can only unstake their tokens after the lock-up period has ended.

# TokenContract.sol
The transfer function has been modified to update the balances correctly and call the stakingContract.updateBalances function if the stakingContract is set.
The approve function now sets the allowance for the spender.
The transferFrom function has been modified to update the balances correctly, deduct the allowance, and call the stakingContract.updateBalances function if the stakingContract is set.
The burn function now reduces the balance and the total supply accordingly, emitting a Transfer event with the burn address as the recipient.

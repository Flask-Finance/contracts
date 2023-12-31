# StakingContract
Manages staking and unstaking of tokens, enabling users to participate in asset staking and earn rewards.

- **constructor(address _tokenContractAddress):** Initializes the contract by setting the address of the TokenContract.
- **stake(uint256 amount):** Allows users to stake a specified amount of tokens. The tokens are transferred from the user to the contract, and the user's balance and the total staked amount are updated. The staking timestamp is recorded.
- **unstake():** Allows users to unstake their tokens if the lock-up period has ended. The tokens are transferred back to the user, and the user's balance and the total staked amount are adjusted accordingly.
- **claimRewards():** Allows users to claim their staking rewards if there are any available. The rewards are transferred to the user, and the user's staking rewards are updated.
- **calculateRewards(address user):** Calculates the rewards for a specific user based on their staked amount and the staking duration. It applies a time-based factor to the rewards based on the proportion of the lock-up period that has passed.
- **isLockUpPeriodFinished(address user):** Checks if the lock-up period has passed for a specific user. It compares the current timestamp with the staking timestamp and returns true if the lock-up period has ended, and false otherwise.
- **updateTokenContract(address _tokenContractAddress):** Allows the contract owner to update the address of the TokenContract.
- **withdrawTokens(address to, uint256 amount):** Allows the contract owner to withdraw excess tokens from the staking contract. Tokens are transferred to the specified recipient address.
- In terms of the lock-up period, it is defined as a constant value `lockUpPeriod` of 30 days in the provided code. The **isLockUpPeriodFinished** function compares the difference between the current timestamp and the staking timestamp to determine if the lock-up period has passed for a specific user. This check is used in the unstake function to ensure users can only unstake their tokens after the lock-up period has ended.

# TokenContract 
Enables the creation, management, and transfer of liquid tokens - representing tangible assets within a blockchain ecosystem.

- **constructor():** Initializes the contract by setting the name, symbol, decimals, and totalSupply of the token.
- **transfer(address to, uint256 value):** Updates the balances correctly and call the `stakingContract.updateBalances` function if the stakingContract is set.
- **approve(address spender, uint256 value):** Sets the allowance for the spender.
- **transferFrom(address from, address to, uint256 value):**: Updates the balances correctly, deducts the allowance, and calls the `stakingContract.updateBalances` function if the stakingContract is set.

# XTokContract 
Facilitates the generation and control of synthetic tokens - virtual representations of diverse liquid assets, enhancing liquidity and accessibility.

- **constructor():** Initializes the contract by setting the name, symbol, decimals, and totalSupply of the token.
- **Mint(address to, uint256 value):** Allows the contract to mint new tokens and increase the total supply. Tokens are minted and transferred to the specified recipient address.
- **Burn(address from, uint256 value):** Allows the contract to burn tokens and decrease the total supply. Tokens are burned from the specified user's balance.

The `XTokContract` is designed to serve as a companion contract for the staking mechanism. It provides the functionality to mint and burn tokens, which is used in conjunction with the staking and unstaking process in the `StakingContract`.

# Interaction between StakingContract and XTokContract
- The `StakingContract` interacts with the `XTokContract` during the staking and unstaking processes. When users stake tokens, the `StakingContract` mints an equivalent amount of tokens in the `XTokContract` using the `Mint` function. These tokens represent the user's staked amount and are used to track their staking - position. When users unstake, the `StakingContract` burns the corresponding tokens in the `XTokContract` using the `Burn` function.
- This interaction allows for a seamless representation of staked tokens as synthetic tokens in the `XTokContract`, facilitating the liquid staking process and ensuring users' staking positions are accurately tracked.
- The `XTokContract` functions as an integral component of the liquid staking ecosystem, enhancing the flexibility and utility of staked assets on the Ethereum blockchain.

# Contract Deployment and Interaction Guide
Follow these steps to deploy the contracts in the correct order and set up allowances for seamless interaction.

## Step 1: Deploy `XTokContract` (Synthetic Tokens)
1. Deploy the `XTokContract` smart contract to manage synthetic tokens.
2. Note the address of the deployed `XTokContract` for later use.

## Step 2: Deploy `TokenContract` (Liquid Tokens)
1. Deploy the `TokenContract` smart contract for liquid token functionality.
2. During deployment, provide the address of the previously deployed `XTokContract`.
3. Note the address of the deployed `TokenContract`.

## Step 3: Set Up Allowance for `StakingContract` 
- Replace `stakingContractAddress` with the actual address of the deployed `StakingContract`.
- Set an appropriate `maxAllowance` value.

## Step 4: Deploy `StakingContract` 
- Deploy the StakingContract to seamlessly interact with the TokenContract. 

## Step 5: Interact with Contracts
- Stake and unstake tokens using the `StakingContract`.

**Note:** Ensure you have the required Solidity compiler version and dependencies.

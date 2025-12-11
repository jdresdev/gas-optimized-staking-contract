# gas-efficient-staking-contract
Single-asset staking contract

Features:
    * Users stake an ERC20 token
    * Rewards accumulate linearly over time. Reward per token approach
    * Any user can claim rewards
    * Reward calculation is O(1)
    * Support emergency withdraw
    * Packed storage optimization
    * Events for indexing
    * Emergency withdraw

reward formula:
rewardPerToken() = rewardPerTokenStored + (rewardRate * (block.timestamp - lastUpdate) * 1e18) / totalStaked

users reward:
earned(user) = userStaked[user] * (rewardPerToken() - userRewardPerTokenPaid[user]) / 1e18 + rewards[user]

Goals:
    1. Allow users to stake an ERC20 token
    2. Distribute rewards over time at a fixed rewardRate
    3. Allow users to claim their rewards at any time
    4. Allow users to withdraw their stake
    5. Keep everthing gas-efficient
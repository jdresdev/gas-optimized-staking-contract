# Gas-Efficient Staking Contract

A minimal and gas-optimized ERC20 staking smart contract that distributes rewards linearly over time using a **reward-per-token** accounting model.

---

## ✨ Features

- Users can stake an ERC20 token
- Rewards accumulate linearly over time
- **Reward-per-token** accounting model
- O(1) reward calculation per user
- Users can claim rewards at any time
- Supports stake withdrawal
- Emergency withdraw support
- Packed storage for gas optimization
- Events emitted for off-chain indexing

---

## 📐 Reward Calculation

### Reward Per Token

```solidity
rewardPerToken() =
    rewardPerTokenStored +
    (rewardRate * (block.timestamp - lastUpdate) * 1e18) / totalStaked;
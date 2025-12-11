// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    // variables
    IERC20 public immutable stakingToken; // we use immutable for performance, safety and gas efficiency. Big gas saving, is cheaper that reading from storage
                                          // staking contracts use immutable for token addresses, owner/admin addresses and pool parameters that never change

    IERC20 public immutable rewardToken;

    uint256 public totalStaked;
    uint256 public rewardRate;
    uint256 public lastUpdate;
    uint256 public rewardPerTokenStored; // reward tokens are owed per 1 staked token, accumulated over time
                                         // increases over time, and each user only cares about the difference between now and their last interaction

    mapping(address => uint256) public userStaked;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    // events
    event Staked(address indexed user, uint256 amount); // indexed is for make parameters searchable and filterable in logs
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 amount);

    // constructor
    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        lastUpdate = block.timestamp; // timestamp of the block in which your transaction is currently being mined
    }

    // modifiers
    

    // external functions

    // internal functions
}
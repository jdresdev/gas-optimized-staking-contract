// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    // variables
    IERC20 public immutable stakingToken; // Immutable for performance, safety and gas efficiency. Is cheaper than reading from storage
                                          // Used for token addresses, owner/admin addresses and pool parameters that never change
    IERC20 public immutable rewardToken;

    uint public totalStaked;
    uint public rewardRate;
    uint public lastUpdate;
    uint public rewardPerTokenStored; // reward tokens are owed per 1 staked token, accumulated over time
                                      // increases over time, and each user only cares about the difference between now and their last interaction

    mapping(address => uint) public userStaked;
    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;

    // events
    event Staked(address indexed user, uint amount); // indexed is for make parameters searchable and filterable in logs
    event Withdrawn(address indexed user, uint amount);
    event RewardPaid(address indexed user, uint amount);

    // constructor
    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        lastUpdate = block.timestamp; // timestamp of the block in which your transaction is currently being mined
    }

    // modifiers
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdate = block.timestamp;

        if(account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    // external functions
    function rewardPerToken() public view returns(uint) {
        if(totalStaked == 0) {
            return rewardPerTokenStored;
        }

        uint time = block.timestamp - lastUpdate;
        uint reward = rewardRate * time * 1e18 / totalStaked;

        return rewardPerTokenStored + reward;
    }

    function earned(address account) public view returns(uint) {
        uint currentRewardPerTokenPaid = rewardPerToken();
        uint userRewardPerTokenPaidValue = userRewardPerTokenPaid[account];

        uint newlyAccrued = userStaked[account] * (currentRewardPerTokenPaid - userRewardPerTokenPaidValue) / 1e18;

        return rewards[account] + newlyAccrued;
    }

    function stake(uint amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot stake zero");


        stakingToken.transferFrom(msg.sender, address(this), amount);

        userStaked[msg.sender] += amount;
        totalStaked += amount;

        emit Staked(msg.sender, amount);
    }

    function withdraw(uint amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");
        require(userStaked[msg.sender] >= amount, "Not enough staked");

        // Update stored balances
        userStaked[msg.sender] -= amount;
        totalStaked -= amount;

        // Transfer tokens
        stakingToken.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    function claim() external updateReward(msg.sender) {
        uint reward = rewards[msg.sender];

        require(reward > 0, "No rewards to claim"); // save gas on empty claims

        rewards[msg.sender] = 0; // prevents double claiming

        rewardToken.transfer(msg.sender, reward);

        emit RewardPaid(msg.sender, reward);
    }

    // get out safely no matter what
    function emergencyWithdraw() external { 
        uint amount = userStaked[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        // Remove staked amount
        userStaked[msg.sender] = 0;
        totalStaked -= amount;

        // Reset rewards to 0
        rewards[msg.sender] = 0;

        stakingToken.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);        
    }

    // internal functions
}
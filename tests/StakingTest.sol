// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

import "remix_tests.sol";
import "remix_accounts.sol";
import "../contracts/SRToken.sol";
import "../contracts/Staking.sol";

contract StakingTest {
    
    SRToken token;
    Staking stakingContract;
    address user;

    function beforeAll() public {
        user = TestsAccounts.getAccount(0);

        // Deploy mock token
        token = new SRToken();

        // Deploy staking contract
        stakingContract = new Staking(address(token), address(token), 1e18);

        // Minting = creating new tokens out of nowhere and assigning them to an address.
        token.transfer(user, 1000 ether); // 1000 * 10^18
    }

    function testStake () public {
        uint expectedStakedTokens = 100 ether;

        // First approve staking contract
        token.approve(address(stakingContract), expectedStakedTokens);

        stakingContract.stake(expectedStakedTokens);

        uint actualStakedTokens = stakingContract.userStaked(address(this));

        Assert.equal(actualStakedTokens, expectedStakedTokens, "User should have staked 100 tokens");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingToken is ERC20 {
    constructor() ERC20("StakingToken", "MTK") {
        _mint(msg.sender, 1_000_000 * 1e18);
    }
}
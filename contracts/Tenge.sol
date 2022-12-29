// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tenge is ERC20 {

    mapping(address=>uint256) public staked;
    mapping(address=>uint256) public stakedTime;

    constructor() ERC20("Tenge", "TNG") {
        _mint(msg.sender, 1000000000000000000);
    }

    function stake(uint256 amount) external {
        require(amount>0, "amount can't be less than 0");
        require(balanceOf(msg.sender)>=amount,"not enough balance");
        _transfer(msg.sender,address(this),amount);
        if (staked[msg.sender]>0){
            claim();
        }
        stakedTime[msg.sender] = block.timestamp;
        staked[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        require(amount>0, "amount can't be less than 0");
        require(staked[msg.sender]>=amount, "staked can't be less than amount");
        claim();
        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claim() public {
        require(staked[msg.sender]>0, "staked can't be less than 0");
        uint256 secStaked = block.timestamp - stakedTime[msg.sender];
        uint256 rewards = staked[msg.sender] * secStaked / 86400; 
        _mint(msg.sender,rewards);
        stakedTime[msg.sender] = block.timestamp;
    }
}
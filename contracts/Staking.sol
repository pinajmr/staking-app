// stake: lock tokens into our smart contract
// withdraw: unlock tokens and pull out of the contract
// claimReward: users get their reward tokens
//          What's a good reward mechanism?
//          What's some good reward math?

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();

contract Staking{

    IERC20 public s_stakingToken;

    // someones address -> how much they stake
    mapping(address => uint256) public  s_balances;

    uint256 public s_totalSupply;

    constructor(address stakingToken){
        s_stakingToken = IERC20(stakingToken);
    }

    // do we allow any tokens? - not  allow any token
    //      Chainlink stuff to convert prices betweenn tokens
    // or just a specific token? :YES:
    function stake(uint256 amount) external {
        // keep track of how much this user has staked
        // keep track of how much token we have total
        // transfer the tokens to this contract
        s_balances[msg.sender] = s_balances[msg.sender] + amount;
        s_totalSupply = s_totalSupply + amount;
        // emit event
        bool success = s_stakingToken.transferFrom(msg.sender,address(this),amount);
        // require(success, "Failed");
        if(!success){
            revert Staking__TransferFailed();
        }
    }

    function withdraw(uint256 amount) external {
        s_balances[msg.sender] = s_balances[msg.sender] - amount;
        s_totalSupply = s_totalSupply - amount;
        bool success = s_stakingToken.transfer(msg.sender, amount);
        // bool success = s_stakingToken.transferFrom(address(this),msg.sender,amount);
        if(!success) {
            revert Staking__TransferFailed();
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./Token.sol";

contract dBank {

  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositeStart;
  mapping(address => bool) public isDeposited;

  event Deposite(address indexed user,uint etherAmount, uint timeStart );
  event Withdraw(address indexed user,uint etherAmount, uint timeStart , uint interset ); 
  Token private token;
  
  constructor(Token _token) public {
    token = _token;
  }

  function deposit() payable public {
    require(isDeposited[msg.sender] == false,"Account is already active..");
    require(msg.value >= 1e16,"deposite should be greater than 0.01ETH.." );
    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    depositeStart[msg.sender] = depositeStart[msg.sender] + block.timestamp;
    isDeposited[msg.sender] = true;
    emit Deposite(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    require(isDeposited[msg.sender] == true,"Account is not Active...");
    uint userBalance = etherBalanceOf[msg.sender];
    uint depositTime = block.timestamp - depositeStart[msg.sender];
    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender]/1e16);
    uint interest = interestPerSecond * depositTime;
    msg.sender.transfer(userBalance);
    etherBalanceOf[msg.sender] = 0;
    token.mint(msg.sender,interest);
    isDeposited[msg.sender] = false;
    depositeStart[msg.sender] = 0;
    emit Withdraw(msg.sender,userBalance,depositTime,interest);
    }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}
/* This smart contract is a simple voting system using the ERC20 token standard.

In this contract:

* A token is deployed 'VoterToken' (VOT).
* VOT has ERC20 functionality thanks to the openzeppelin library
* An address holding the VOT token can set a voting option as a number between 1 - 5.
* When they vote their address is mapped to their voting value and can be checked by the contract deployer.



-------------------------------------------------------------   */ 



// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VotingToken is ERC20 {

    uint voteNum = 0;
    address owner;

    constructor() ERC20 ("VoterToken", "VOT") {

        owner = msg.sender;
        // '_' signifes internal function
        _mint(owner, 1000 * 10 ** 18);
    }   


    // Set a Mapping to have the vote value associated the voter address.

    mapping(address => uint) private id;


    // Set a modifier to check that the address voting has more than zero VoterToken (VOT).

    modifier checkAddressValue() {
        require(balanceOf(msg.sender) > 0,"Must Hold VoterToken (VOT) to Vote!");
        _;
    }

    // Set a modifier to check that the function being called is only accessible by the contract deployer.

    
    modifier onlyOwner() {
        require (msg.sender == owner, "You are not contract owner.");
        _;
    }

    
    // Function to vote / store value. If an address has VoterToken they may choose a number 
    // between 1 - 5 and their answer will be stored in the mapping.
    
    function vote(uint _value) public checkAddressValue returns (uint) {
        require(_value <= 5 && _value != 0);
        uint value = _value;
        id[msg.sender]= value;
        return value;
    }

    // Function will check the balance of VoterToken (VOT) of an address to confirm their
    // voting eligibility.


    function checkBalance(address _address) public view onlyOwner returns (uint) {
        return balanceOf(_address);
    }


    // Function gets the uint value set by msg.sender set in the 'vote' function. 


    function getValue() public view onlyOwner returns (uint) {
        return id[msg.sender];
    }


}
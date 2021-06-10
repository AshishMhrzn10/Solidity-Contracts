//SPDX-License-Identifier:MIT 
pragma solidity ^0.5.0;

contract Lottery{
    address public owner;
    address payable[] public players;
    address payable public winner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier ownerOnly{
        require(
             msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }
    
    function deposit() public payable{
        require(msg.value >= 1 ether);
        players.push(msg.sender);
    }
    
    function GenerateRandomNum() private view returns(uint){
        return uint(keccak256(abi.encodePacked(now, block.difficulty, players.length)));
    }
    
    function pickWinner() ownerOnly public{
        uint randomNumber = GenerateRandomNum();
        uint index = randomNumber % players.length;
        
        winner = players[index];
        winner.transfer(address(this).balance);
        
        players = new address payable [](0);
    }
}
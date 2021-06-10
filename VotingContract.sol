//SPDX-License-Identifier:MIT 
pragma solidity ^0.8.0;

contract voting{
    address public contractOwner;
    address [] public candidatesList;
    mapping(address => uint8) votesRecieved;
    address public winner;
    uint public winnerVotes;
    
    enum votingStatus {NotStarted, Running, Completed}
    votingStatus public status;
    
    constructor(){
        contractOwner = msg.sender; 
    }
    
    modifier OwnerOnly{
        require(msg.sender == contractOwner,"Only message owner can use this");
        _;
    }
    
    function setStatus() OwnerOnly public{
        if(status ==votingStatus.NotStarted){
            status = votingStatus.Running;
        }else if(status == votingStatus.Running){
            status = votingStatus.Completed;
        }
    }
    
    function registerCandidates(address _candidate) OwnerOnly public{
        candidatesList.push(_candidate);
    }
    
    function vote(address _candidate) public{
        require(validateCandidate(_candidate),"Invalid candidate address");
        require(status == votingStatus.Running,"Election is not running");  //assert(status == votingStatus.Running)
        votesRecieved[_candidate] = votesRecieved[_candidate]+1;    // votesRecieved[_candidate]++;
    }
    
    function validateCandidate(address _candidate) view private returns(bool){
        for(uint i=0;i<candidatesList.length;i++){
            if(candidatesList[i] == _candidate){
                return true;
            }
        }
        return false;
    }
    
    function votesCount(address _candidate) public view returns(uint){
        require(validateCandidate(_candidate),"Invalid candidate address");
        require(status == votingStatus.Running,"Election is not running");
        return votesRecieved[_candidate];
    }
    
    function result() public {
        require(status == votingStatus.Completed,"Election is in progress.");
        for(uint i=0; i<candidatesList.length; i++){
            if(votesRecieved[candidatesList[i]] > winnerVotes){
                winnerVotes = votesRecieved[candidatesList[i]];
                winner = candidatesList[i];
            }
        }
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract VotingSystem {

    // Struct to represent a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // Mapping to store candidates by their ID
    mapping(uint256 => Candidate) public candidates;

    // Array to keep track of all candidate IDs
    uint256[] private candidateIds;

    // Mapping to track whether an address has voted
    mapping(address => bool) public voters;

    // Variable to store the winner of the election
    Candidate public winner;

    // Event emitted when a new candidate is added
    event CandidateAdded(uint256 id, string name);

    // Event emitted when a vote is cast
    event VoteCast(address voter, uint256 candidateId);

    // Event emitted when the winner is declared
    event WinnerDeclared(uint256 candidateId);

    function getCandidate(uint256 _index) external view returns (uint256) {
        require(candidateIds.length > _index, "Index not found");
        return candidateIds[_index];
    }

    // Function to add a new candidate
    function addCandidate(string memory _name) public {
        // Increment the candidate ID counter
        uint256 newCandidateId = candidateIds.length;

        // Create a new candidate struct
        Candidate memory newCandidate = Candidate(newCandidateId, _name, 0);

        // Store the new candidate in the mapping
        candidates[newCandidateId] = newCandidate;

        // Add the new candidate ID to the array
        candidateIds.push(newCandidateId);

        // Emit the CandidateAdded event
        emit CandidateAdded(newCandidateId, _name);
    }

    // Function to cast a vote for a candidate
    function castVote(uint256 _candidateId) public {
        // Ensure that the voter has not voted before
        require(voters[msg.sender] == false, "You have already voted.");

        // Increment the vote count for the candidate
        candidates[_candidateId].voteCount++;

        // Mark the voter as having voted
        voters[msg.sender] = true;

        // Emit the VoteCast event
        emit VoteCast(msg.sender, _candidateId);
    }

    // Function to return the total number of votes for a candidate
    function getVoteCount(uint256 _candidateId) public view returns (uint256) {
        return candidates[_candidateId].voteCount;
    }

    // Function to declare the winner of the election
    function declareWinner() public {
        // Find the candidate with the highest vote count
        uint256 highestVoteCount = 0;
        uint256 winnerId = 0;
        for (uint256 i = 0; i < candidateIds.length; i++) {
            uint256 candidateId = candidateIds[i];
            if (candidates[candidateId].voteCount > highestVoteCount) {
                highestVoteCount = candidates[candidateId].voteCount;
                winnerId = candidateId;
            }
        }

        // Set the winner variable to the candidate with the highest vote count
        winner = candidates[winnerId];

        // Emit the WinnerDeclared event
        emit WinnerDeclared(winnerId);
    }
}


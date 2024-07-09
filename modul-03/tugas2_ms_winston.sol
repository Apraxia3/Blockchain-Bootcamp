// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract UpgradedMembershipSystem {
    // Enum for membership types
    enum MembershipType { Basic, Premium, VIP }

    // Struct to define a Member
    struct Member {
        uint256 id;
        string name;
        uint256 balance;
        MembershipType membershipType;
    }

    // Mapping to store members by their address
    mapping(address => Member) private members;
    // Additional mapping to track membership status
    mapping(address => bool) private memberExists;

    // Counter for Member ID
    uint256 private memberIdCounter = 1;

    // Function to add a new member
    function addMember(address _member, string memory _name, uint256 _balance, MembershipType _membershipType) external {
        require(!memberExists[_member], "Member already exists");
        members[_member] = Member({
            id: memberIdCounter,
            name: _name,
            balance: _balance,
            membershipType: _membershipType
        });
        memberExists[_member] = true;
        memberIdCounter++;
    }

    // Function to remove an existing member
    function removeMember(address _member) external {
        require(memberExists[_member], "Member does not exist");
        delete members[_member];
        memberExists[_member] = false;
    }

    // Function to check if an address is a member
    function isMember(address _member) external view returns (bool) {
        return memberExists[_member];
    }

    // Function to modify a member's information
    function modifyMember(address _member, string memory _name, uint256 _balance, MembershipType _membershipType) external {
        require(memberExists[_member], "Member does not exist");
        members[_member].name = _name;
        members[_member].balance = _balance;
        members[_member].membershipType = _membershipType;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract MembershipSystem {
    // Mapping to store members by their address
    mapping(address => bool) private members;

    // Function to add a new member
    function addMember(address _member) external {
        members[_member] = true;
    }

    // Function to remove an existing member
    function removeMember(address _member) external {
        members[_member] = false;
    }

    // Function to check if an address is a member
    function isMember(address _member) external view returns (bool) {
        return members[_member];
    }
}


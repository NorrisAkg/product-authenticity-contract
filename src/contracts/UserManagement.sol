// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {console} from "forge-std/Test.sol";
import {User, UserRole} from "./../abstract/Types.sol";

contract UserManagement {
    address public immutable contractOwner;

    // Events
    event UserRegistered(string username, string avatar, UserRole role);
    event AdminAdded();
    event ValidatorAdded();

    // Mappings
    mapping(address => User) public addressToUser;
    mapping(address => bool) public registeredUsers;

    // Arrays
    address[] public admins;
    address[] validators;

    constructor() {
        contractOwner = msg.sender;
        admins.push(contractOwner);
    }

    // Fonctions

    // Register user
    function registerUser(
        string memory _username,
        string memory _avatar
    ) public {
        // Create user
        addressToUser[msg.sender] = User(
            _username,
            _avatar,
            UserRole.User,
            block.timestamp
        );

        // Set new user registered status as true
        registeredUsers[msg.sender] = true;

        emit UserRegistered(_username, _avatar, UserRole.User);
    }

    // Add new admin
    function addAdmin(
        address _address,
        string memory _username,
        string memory _avatar
    ) public onlyOwner(msg.sender) notAdminYet(_address) {
        addressToUser[_address] = User(
            _username,
            _avatar,
            UserRole.Admin,
            block.timestamp
        );
        admins.push(_address);

        // Set new user registered status as true
        registeredUsers[_address] = true;

        emit AdminAdded();
    }

    // Add new validator
    function addValidator(
        address _address,
        string memory _username,
        string memory _avatar
    ) public onlyOwner(msg.sender) notValidatorYet(_address) {
        addressToUser[_address] = User(
            _username,
            _avatar,
            UserRole.Validator,
            block.timestamp
        );
        validators.push(_address);

        // Set new user registered status as true
        registeredUsers[_address] = true;

        emit ValidatorAdded();
    }

    function showUserInfos(
        address _address
    )
        public
        view
        userIsRegistered(_address)
        returns (address, string memory, string memory, UserRole role)
    {
        User storage user = addressToUser[_address];

        return (_address, user.username, user.avatar, user.role);
    }

    function getAdmins() public view returns (address[] memory) {
        return admins;
    }

    function getValidators() public view returns (address[] memory) {
        return validators;
    }

    function getUserStatus(address _address) public view returns (bool) {
        return registeredUsers[_address];
    }

    // Modifiers
    modifier userIsRegistered(address _address) {
        console.log("address passed :", _address);
        console.log("address passed is registered", registeredUsers[_address]);
        require(registeredUsers[_address], "User is not registered");
        _;
    }

    modifier notAdminYet(address _address) {
        bool exists = false;

        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == _address) {
                exists = true;
                break;
            }
        }

        require(!exists, "This address is already an admin");
        _;
    }

    modifier notValidatorYet(address _address) {
        bool exists = false;

        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == _address) {
                exists = true;
                break;
            }
        }

        require(!exists, "This address is already a validator");
        _;
    }

    modifier onlyOwner(address _address) {
        require(
            _address == contractOwner,
            "Only admin can perform this action"
        );
        _;
    }

    modifier onlyValidator(address _address) {
        require(
            addressToUser[_address].role == UserRole.Validator,
            "Only admin can perform this action"
        );
        _;
    }

    // modifier onlyRegisteredUser(address _address) {
    //     require(registeredUsers[_address], "User is not registered");
    //     _;
    // }
}

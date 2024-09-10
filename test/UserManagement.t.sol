// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {UserManagement} from "./../src/contracts/UserManagement.sol";
import {UserRole} from "./../src/abstract/Types.sol";

contract UserManagementTest is Test {
    UserManagement userManagement;
    address contractOwner;

    function beforeTestSetup() public {
        // userManagement.clearAdmins();
    }

    function setUp() public {
        userManagement = new UserManagement();
        // contractOwner = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    }

    function test_AddAmin() public {
        address _address = 0x1BCd7ae6473d1c203AcED7cFf21cC86E3E7d969F;
        string memory _username = "";
        string memory _avatar = "";

        userManagement.addAdmin(_address, _username, _avatar);

        (
            address returnedAddress,
            string memory returnedUsername,
            string memory returnedAvatar,
            UserRole returnedRole
        ) = userManagement.showUserInfos(_address);

        assertEq(returnedAddress, _address, "Address should match");
        assertEq(returnedUsername, _username, "Username should match");
        assertEq(returnedAvatar, _avatar, "Avatar should match");
        assertEq(
            uint8(returnedRole),
            uint8(UserRole.Admin),
            "Role should be Admin"
        );
        assertEq(
            userManagement.getAdmins().length,
            2,
            "Admins length should be 2"
        );
    }

    function test_AddValidator() public {
        address _address = 0x1BCd7ae6473d1c203AcED7cFf21cC86E3E7d969F;
        string memory _username = "";
        string memory _avatar = "";

        userManagement.addValidator(_address, _username, _avatar);

        (
            address returnedAddress,
            string memory returnedUsername,
            string memory returnedAvatar,
            UserRole returnedRole
        ) = userManagement.showUserInfos(_address);

        assertEq(returnedAddress, _address, "Address should match");
        assertEq(returnedUsername, _username, "Username should match");
        assertEq(returnedAvatar, _avatar, "Avatar should match");
        assertEq(
            uint8(returnedRole),
            uint8(UserRole.Validator),
            "Role should be validator"
        );
        assertEq(
            userManagement.getValidators().length,
            1,
            "Validator length should be 1"
        );
    }

    function test_RevertIfAdminAlreadyExists() public {
        address _address = 0x1BCd7ae6473d1c203AcED7cFf21cC86E3E7d969F;

        userManagement.addAdmin(_address, "No name", "no avatar");

        vm.expectRevert("This address is already an admin");

        userManagement.addAdmin(_address, "No name", "no avatar");
    }

    function test_RevertIfValidatorAlreadyExists() public {
        address _address = 0x1BCd7ae6473d1c203AcED7cFf21cC86E3E7d969F;

        userManagement.addValidator(_address, "No name", "no avatar");

        vm.expectRevert("This address is already a validator");

        userManagement.addValidator(_address, "No name", "no avatar");
    }

    function test_RegisterUser() public {
        address _address = 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25;

        // Set msg sender
        vm.prank(_address);

        string memory _username = "Arris Coolkid";
        string
            memory _avatar = "QmXnnyufdzAWL5CqT9RnSNgPbvCc1ALT73s6epPrRnZ1Xy";

        userManagement.registerUser(_username, _avatar);

        (
            address returnedAddress,
            string memory returnedUsername,
            string memory returnedAvatar,
            UserRole returnedRole
        ) = userManagement.showUserInfos(_address);

        assertEq(returnedAddress, _address, "Address should match");
        assertEq(returnedUsername, _username, "Username should match");
        assertEq(returnedAvatar, _avatar, "Avatar should match");
        assertEq(
            uint8(returnedRole),
            uint8(UserRole.User),
            "Avatar should match"
        );
    }
}

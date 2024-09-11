// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "../src/contracts/ProductAuthenticityContract.sol";
import "forge-std/Test.sol";
import "./../src/contracts/UserManagement.sol";
import "./../src/contracts/ProductRegistration.sol";
import "./../src/contracts/ProductValidation.sol";
import "./Mocks/MockUserManagement.sol";

contract ProductAuthenticityContractTest is Test {
    ProductAuthenticityContract productAuthenticityContract;
    UserManagement userManagementContract;
    ProductRegistration productRegistrationContract;
    ProductValidation productValidationContract;

    function setUp() public {
        userManagementContract = new UserManagement();
        productRegistrationContract = new ProductRegistration();
        productValidationContract = new ProductValidation();

        productAuthenticityContract = new ProductAuthenticityContract(
            address(userManagementContract),
            address(productRegistrationContract),
            address(productValidationContract)
        );
    }

    function test_RegisterUser() public {
        address _address = 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25;
        vm.prank(_address);
        productAuthenticityContract.registerUser("John Doe", "avatarHash");

        assertEq(
            productAuthenticityContract.checkIfUserIsRegistered(_address),
            true,
            "User should be registered"
        );

        (
            address returnedAddress,
            string memory returnedUsername,
            string memory returnedAvatar,
            UserRole returnedRole
        ) = productAuthenticityContract.showUserInfos(_address);

        // Assertions ou vérifications sur ce qui devrait se passer
        assertEq(returnedAddress, (_address), "Address should match");
        assertEq(returnedUsername, "John Doe", "Username should match");
        assertEq(returnedAvatar, "avatarHash", "Avatar should match");
        assertEq(
            uint8(returnedRole),
            uint8(UserRole.User),
            "Role should match"
        );
    }
}

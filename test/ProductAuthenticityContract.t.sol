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
        productAuthenticityContract.registerUser("JohnDoe", "avatarHash");

        // Assertions ou vérifications sur ce qui devrait se passer
    }
}

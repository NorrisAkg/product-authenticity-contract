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

    function mockUserRegistration(
        address _address,
        string memory _username,
        string memory _avatar
    ) public {}

    function mockProductRegistration(address _address) private {
        string memory serialNumber = "123ABC";
        string memory designation = "Laptop";
        string memory description = "High-end gaming laptop";
        string
            memory pictureHash = "QmXnnyufdzAWL5CqZ2RnSNgPbvCc1ALT73s6epPrRnZ1Xy";
        uint price = 1500;

        vm.prank(_address);
        productAuthenticityContract.registerProduct(
            serialNumber,
            designation,
            description,
            pictureHash,
            price
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

    function test_AddProduct() public {
        address _address = 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25;
        string memory _username = "Arris Coolkid";
        string
            memory _avatar = "QmXnnyufdzAWL5CqT9RnSNgPbvCc1ALT73s6epPrRnZ1Xy";

        vm.prank(_address);
        productAuthenticityContract.registerUser(_username, _avatar);

        assertEq(
            productAuthenticityContract.checkIfUserIsRegistered(_address),
            true,
            "User should be registered"
        );

        console.log("contract address :", address(this));
        console.log(
            "user management address :",
            address(userManagementContract)
        );
        console.log(
            "product registration contract address :",
            address(productRegistrationContract)
        );
        console.log("msg sender", _address);

        vm.prank(_address);
        mockProductRegistration(_address);

        (
            uint id,
            string memory returnedSerialNumber,
            string memory returnedDesignation,
            string memory returnedDescription,
            string memory returnedPictureHash,
            uint returnedPrice,
            ,
            address manufacturer,
            address owner,
            ProductStatus status,
            address[] memory owners
        ) = productAuthenticityContract.getProductInfos(1);

        assertEq(id, 1);
        assertEq(returnedSerialNumber, "123ABC");
        assertEq(returnedDesignation, "Laptop");
        assertEq(returnedDescription, "High-end gaming laptop");
        assertEq(
            returnedPictureHash,
            "QmXnnyufdzAWL5CqZ2RnSNgPbvCc1ALT73s6epPrRnZ1Xy"
        );
        assertEq(returnedPrice, 1500);
        assertEq(manufacturer, 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        console.log("returned owner", owner);
        assertEq(owner, 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        assertEq(owners.length, 1);
        assertEq(uint8(status), uint8(ProductStatus.Pending));
        assertEq(owners[0], 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
    }

    function test_UpdateProduct() public {
        address _address = 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25;
        string memory _username = "Arris Coolkid";
        string
            memory _avatar = "QmXnnyufdzAWL5CqT9RnSNgPbvCc1ALT73s6epPrRnZ1Xy";

        vm.prank(_address);
        productAuthenticityContract.registerUser(_username, _avatar);

        // vm.prank(_address);
        mockProductRegistration(_address);

        vm.prank(_address);
        productAuthenticityContract.updateProduct(
            1,
            "123ABC",
            "Gaming Laptop Lenovo",
            "",
            "QmXnnyufdzAWL5CqZ2RnSNgPbvCc1ALT73s6epPrRnZ1Xy",
            50000
        );

        (
            uint id,
            string memory returnedSerialNumber,
            string memory returnedDesignation,
            string memory returnedDescription,
            string memory returnedPictureHash,
            uint returnedPrice,
            ,
            address manufacturer,
            address owner,
            ProductStatus status,
            address[] memory owners
        ) = productAuthenticityContract.getProductInfos(1);

        assertEq(id, 1);
        assertEq(returnedSerialNumber, "123ABC");
        assertEq(returnedDesignation, "Gaming Laptop Lenovo");
        assertEq(returnedDescription, "High-end gaming laptop");
        assertEq(
            returnedPictureHash,
            "QmXnnyufdzAWL5CqZ2RnSNgPbvCc1ALT73s6epPrRnZ1Xy"
        );
        assertEq(returnedPrice, 50000);
        assertEq(manufacturer, 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        assertEq(owner, 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        assertEq(owners.length, 1);
        assertEq(uint8(status), uint8(ProductStatus.Pending));
        assertEq(owners[0], 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
    }
}

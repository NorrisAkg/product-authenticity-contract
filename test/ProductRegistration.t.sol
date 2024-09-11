// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Product, UserRole, ProductStatus} from "./../src/abstract/Types.sol";
import {ProductRegistration} from "./../src/contracts/ProductRegistration.sol";
import {UserManagement} from "./../src/contracts/UserManagement.sol";

contract ProductRegistrationTest is Test {
    ProductRegistration productRegistration;

    function setUp() public {
        // vm.startPrank(0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        productRegistration = new ProductRegistration();
    }

    function test_AddProduct() public {
        address _address = 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25;
        // vm.startPrank(_address);
        string memory _username = "Arris Coolkid";
        string
            memory _avatar = "QmXnnyufdzAWL5CqT9RnSNgPbvCc1ALT73s6epPrRnZ1Xy";

        vm.prank(_address);
        // productRegistration.registerUser(_username, _avatar);

        // (
        //     address returnedAddress,
        //     string memory returnedUsername,
        //     string memory returnedAvatar,
        //     UserRole returnedRole
        // ) = productRegistration.showUserInfos(_address);

        // assertEq(returnedAddress, _address, "Address should match");
        // assertEq(returnedUsername, _username, "Username should match");
        // assertEq(returnedAvatar, _avatar, "Avatar should match");
        // assertEq(
        //     uint8(returnedRole),
        //     uint8(UserRole.User),
        //     "Avatar should match"
        // );

        string memory serialNumber = "123ABC";
        string memory designation = "Laptop";
        string memory description = "High-end gaming laptop";
        string
            memory pictureHash = "QmXnnyufdzAWL5CqZ2RnSNgPbvCc1ALT73s6epPrRnZ1Xy";
        uint price = 1500;

        // assertEq(
        //     productRegistration.getUserStatus(_address),
        //     true,
        //     "Should be true"
        // );

        console.log("address :", address(this));
        // console.log(
        //     "address status",
        //     productRegistration.getUserStatus(address(this))
        // );

        vm.prank(_address);
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
        ) = productRegistration.showProductInfos(1);

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
        assertEq(owner, 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
        assertEq(owners.length, 1);
        assertEq(uint8(status), uint8(ProductStatus.Pending));
        assertEq(owners[0], 0x30B83DcDdD90c73884D46fd27313EeFc665bdc25);
    }
}

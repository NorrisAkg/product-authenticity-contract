// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {UserManagement} from "../src/contracts/UserManagement.sol";
import {ProductRegistration} from "../src/contracts/ProductRegistration.sol";
import {ProductValidation} from "../src/contracts/ProductValidation.sol";
import {ProductAuthenticityContract} from "../src/contracts/ProductAuthenticityContract.sol";

contract CounterScript is Script {
    ProductAuthenticityContract public productAuthenticityContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        UserManagement userManagementContract = new UserManagement();
        ProductRegistration productRegistrationContract = new ProductRegistration();
        ProductValidation productValidationContract = new ProductValidation();

        productAuthenticityContract = new ProductAuthenticityContract(
            address(userManagementContract),
            address(productRegistrationContract),
            address(productValidationContract)
        );

        vm.stopBroadcast();
    }
}

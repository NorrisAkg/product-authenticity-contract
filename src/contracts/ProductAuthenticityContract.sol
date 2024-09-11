// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./../interfaces/IUserManagement.sol";
import "./../interfaces/IProductRegistration.sol";
import "./../interfaces/IProductValidation.sol";
import "forge-std/console.sol";

contract ProductAuthenticityContract {
    IUserManagement userManagementContract;
    IProductRegistration productRegistrationContract;
    IProductValidation productValidationContract;

    constructor(
        address _userManagementAddress,
        address _productRegistrationAddress,
        address _productValidationAddress
    ) {
        userManagementContract = IUserManagement(_userManagementAddress);
        productRegistrationContract = IProductRegistration(
            _productRegistrationAddress
        );
        productValidationContract = IProductValidation(
            _productValidationAddress
        );
    }

    // User and roles functions
    function registerUser(
        string memory _username,
        string memory _avatar
    ) public {
        console.log("Trying to register user");
        userManagementContract.registerUser(msg.sender, _username, _avatar);
        console.log("User registered:", _username, _avatar);
    }

    function addAdmin(
        address _address,
        string memory _username,
        string memory _avatar
    ) public {
        userManagementContract.addAdmin(_address, _username, _avatar);
    }

    function addValidator(
        address _address,
        string memory _username,
        string memory _avatar
    ) public {
        userManagementContract.addValidator(_address, _username, _avatar);
    }

    function checkIfUserIsRegistered(
        address _address
    ) public view returns (bool) {
        return userManagementContract.checkIfUserIsRegistered(_address);
    }

    function showUserInfos(
        address _address
    )
        public
        view
        returns (address, string memory, string memory, UserRole role)
    {
        // require(checkIfUserIsRegistered(_address), "User is not registered");
        return userManagementContract.showUserInfos(_address);
    }

    function getAdmins() public view {
        userManagementContract.getAdmins();
    }

    function getValidators() public view {
        userManagementContract.getValidators();
    }

    // Product registration functions
    function registerProduct(
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        uint _price
    ) public {
        require(
            userManagementContract.checkIfUserIsRegistered(msg.sender),
            "User is not registered"
        );

        productRegistrationContract.addProduct(
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price
        );
    }

    function addValidation(uint _productId, ProductStatus _status) public {
        require(
            userManagementContract.getUserRole(msg.sender) ==
                UserRole.Validator,
            "Only validators can add validations"
        );

        productValidationContract.addValidationToProduct(
            _productId,
            _status,
            userManagementContract.getValidators().length
        );
    }

    // Modifiers
}

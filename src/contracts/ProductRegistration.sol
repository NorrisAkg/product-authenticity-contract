// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// import {console} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "./../interfaces/IUserManagement.sol";
import "./../abstract/BaseProductContract.sol";
import {Product, ProductStatus, Validation} from "./../abstract/Types.sol";

contract ProductRegistration is BaseProductContract {
    error ProductRegistration_InvalidSerialNumber();

    function addProduct(
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        address _manufacturer,
        uint _price
    ) public checkSerialNumberExisting(_serialNumber) {
        Product memory product = Product(
            productCounter,
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price,
            block.timestamp,
            _manufacturer,
            _manufacturer,
            ProductStatus.Pending,
            new address[](0),
            0,
            0
        );

        products.push(product);
        idToProduct[productCounter] = product;

        registerNewOwner(productCounter, _manufacturer);

        emit ProductAdded(
            productCounter,
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price,
            block.timestamp,
            _manufacturer,
            _manufacturer,
            ProductStatus.Pending
        );

        registeredProducts[_serialNumber] = true;
        productCounter++;
    }

    function updateProduct(
        address _msgSender,
        uint _productId,
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        uint _price
    )
        public
        checkProductExisting(_productId)
        onlyProductManufacturer(_productId, _msgSender)
    {
        Product storage product = idToProduct[_productId];

        if (
            keccak256(bytes(product.serialNumber)) !=
            keccak256(bytes(_serialNumber)) &&
            registeredProducts[_serialNumber]
        ) {
            revert ProductRegistration_InvalidSerialNumber();
        }

        product.serialNumber = bytes(_serialNumber).length > 0
            ? _serialNumber
            : product.serialNumber;
        product.designation = bytes(_designation).length > 0
            ? _designation
            : product.designation;
        product.description = bytes(_description).length > 0
            ? _description
            : product.description;
        product.pictureHash = bytes(_serialNumber).length > 0
            ? _pictureHash
            : product.pictureHash;
        product.price = _price > 0 ? _price : product.price;

        emit ProductUpdated(
            _productId,
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price,
            product.owner
        );
    }
}

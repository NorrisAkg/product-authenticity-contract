// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// import {console} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "./../interfaces/IUserManagement.sol";
import "./../abstract/BaseProductContract.sol";
import {Product, ProductStatus, Validation} from "./../abstract/Types.sol";

contract ProductRegistration is BaseProductContract {
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
        uint _productId,
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        uint _price
    )
        public
        checkProductExisting(_productId)
        checkSerialNumberExisting(_serialNumber)
        onlyProductManufacturer(_productId, msg.sender)
    {
        Product storage product = idToProduct[_productId];
        product.serialNumber = _serialNumber;
        product.designation = _designation;
        product.description = _description;
        product.pictureHash = _pictureHash;
        product.price = _price;

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

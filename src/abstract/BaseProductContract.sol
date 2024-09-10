// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./../interfaces/IProductRegistration.sol";
import "./../interfaces/IUserManagement.sol";
import {Product, ProductStatus, Validation} from "./Types.sol";

abstract contract BaseProductContract {
    event ProductAdded(
        uint _id,
        string _serialNumber,
        string _designation,
        string _description,
        string _pictureHash,
        uint256 _price,
        uint256 _registrationDate,
        address _manufacturer,
        address _owner,
        ProductStatus _status
    );

    event ProductUpdated(
        uint _id,
        string _serialNumber,
        string _designation,
        string _description,
        string _pictureHash,
        uint256 _price,
        address _owner
    );

    uint productCounter = 1;
    mapping(uint => Product) public idToProduct;
    // mapping(uint => bool) public registeredProducts;
    mapping(string => bool) public registeredProducts;
    mapping(address => uint) public ownerProductsCount;
    Product[] products;

    function showProductInfos(
        uint _productId
    )
        public
        view
        returns (
            uint _id,
            string memory _serialNumber,
            string memory _designation,
            string memory _description,
            string memory _pictureHash,
            uint _price,
            uint _registrationDate,
            address _manufacturer,
            address _owner,
            ProductStatus _status,
            address[] memory _owners
        )
    {
        Product memory product = idToProduct[_productId];

        return (
            product.id,
            product.serialNumber,
            product.designation,
            product.description,
            product.pictureHash,
            product.price,
            product.registrationDate,
            product.manufacturer,
            product.owner,
            product.status,
            product.owners
        );
    }

    function registerNewOwner(uint _productId, address _owner) internal {
        Product storage product = idToProduct[_productId];
        product.owners.push(_owner);
    }

    // Modifiers
    modifier checkSerialNumberExisting(string memory _serialNumber) {
        require(
            !registeredProducts[_serialNumber],
            "A product with this serial number already exists"
        );
        _;
    }

    modifier checkProductExisting(uint _productId) {
        require(
            registeredProducts[idToProduct[_productId].serialNumber],
            "Product doesn't exist"
        );
        _;
    }

    modifier notValidatedYet(uint _productId) {
        require(
            idToProduct[_productId].status == ProductStatus.Validated ||
                idToProduct[_productId].status == ProductStatus.Refused,
            "Product already validated"
        );
        _;
    }

    modifier onlyProductManufacturer(uint _productId, address _address) {
        require(idToProduct[_productId].manufacturer == _address);
        _;
    }
}

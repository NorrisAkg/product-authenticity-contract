// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// import {console} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "./UserManagement.sol";
import {Product, ProductStatus, Validation} from "./../../abstract/Types.sol";

contract ProductRegistration is UserManagement {
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
        uint256 _price
    );

    uint productCounter = 1;
    mapping(uint => Product) public idToProduct;
    // mapping(uint => bool) public registeredProducts;
    mapping(string => bool) public registeredProducts;
    mapping(address => uint) public ownerProductsCount;
    Product[] products;

    constructor() UserManagement() {
        // Initialisation spécifique à ProductRegistration
    }

    function addProduct(
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        uint _price
    )
        public
        checkSerialNumberExisting(_serialNumber)
    // onlyRegisteredUser(msg.sender)
    {
        console.log("msg sender", msg.sender);
        Product memory product = Product(
            productCounter,
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price,
            block.timestamp,
            msg.sender,
            msg.sender,
            ProductStatus.Pending,
            new address[](0),
            0,
            0
        );

        products.push(product);
        idToProduct[productCounter] = product;

        registerNewOwner(productCounter, msg.sender);

        emit ProductAdded(
            productCounter,
            _serialNumber,
            _designation,
            _description,
            _pictureHash,
            _price,
            block.timestamp,
            msg.sender,
            msg.sender,
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
            _price
        );
    }

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

    function registerNewOwner(uint _id, address _owner) internal {
        Product storage product = idToProduct[_id];
        product.owners.push(_owner);
    }

    modifier onlyRegisteredUser(address _address) {
        console.log("Checking user:", _address);
        require(getUserStatus(_address), "User is not registered");
        _;
    }

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
            // registeredProducts[_productId],
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

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {ProductStatus} from "./../abstract/Types.sol";

interface IProductRegistration {
    function addProduct(
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        address _manufacturer,
        uint _price
    ) external;

    function updateProduct(
        address _msgSender,
        uint _productId,
        string memory _serialNumber,
        string memory _designation,
        string memory _description,
        string memory _pictureHash,
        uint _price
    ) external;

    function showProductInfos(
        uint _productId
    )
        external
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
        );
}

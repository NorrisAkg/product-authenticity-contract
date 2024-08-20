// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {ProductStatus} from "./../../abstract/Types.sol";

interface IProductValidation {
    function addValidationToProduct(
        uint _productId,
        ProductStatus _status
    ) external;

    function getProductStatus(
        uint _productId
    ) external view returns (ProductStatus);
}

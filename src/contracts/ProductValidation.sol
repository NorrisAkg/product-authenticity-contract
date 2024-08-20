// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./ProductRegistration.sol";
import "./../../abstract/Types.sol";

contract ProductValidationContract is ProductRegistration {
    mapping(uint => Validation[]) public productValidations;

    function validateProduct(uint _productId) private {
        Product storage product = idToProduct[_productId];
        // Get validators count
        uint validatorsCount = getValidators().length;

        uint acceptedValidationsPercentage = (product.acceptedValidationsCount *
            100) / validatorsCount;

        uint refusedValidationsPercentage = (product.refusedValidationsCount *
            100) / validatorsCount;

        if (acceptedValidationsPercentage > 50) {
            product.status = ProductStatus.Validated;
        } else if (refusedValidationsPercentage > 50) {
            product.status = ProductStatus.Refused;
        }
    }

    // Add new validation by validator
    function addValidationToProduct(
        uint _productId,
        ProductStatus _status
    )
        public
        checkProductExisting(_productId)
        onlyValidator(msg.sender)
        notGaveValidationYet(_productId, msg.sender)
    {
        Product storage product = idToProduct[_productId];

        // Create new validation
        Validation memory validation = Validation(
            productValidations[_productId].length + 1,
            _status,
            msg.sender
        );

        // Add validation
        productValidations[_productId].push(validation);
        // product.validations.push(validation);

        // Increment product validations count (accepted or refused)
        _status == ProductStatus.Validated
            ? product.acceptedValidationsCount++
            : product.refusedValidationsCount++;

        // Set product validation status
        validateProduct(_productId);
    }

    function getProductStatus(
        uint _productId
    ) public view onlyValidator(msg.sender) returns (ProductStatus) {
        (, , , , , , , , , ProductStatus _status, ) = showProductInfos(
            _productId
        );

        return _status;
    }

    // Modifiers
    modifier notGaveValidationYet(uint256 _productId, address _address) {
        bool validationAlreadyGiven = false;
        for (uint256 i = 0; i < productValidations[_productId].length; i++) {
            if (productValidations[_productId][i].validator == _address) {
                validationAlreadyGiven = true;
                break;
            }
        }
        require(
            !validationAlreadyGiven,
            "This validator has already given his validation on this product"
        );
        _;
    }
}

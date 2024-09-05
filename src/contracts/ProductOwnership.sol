// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import "./ProductRegistration.sol";

/// @title Product Ownership Contract
/// @author
/// @notice Handles products ownership transfers
contract ProductOwnership is ProductRegistration {
    function transferOwnership(
        uint _productId,
        address _newOwner
    ) public checkProductExisting(_productId) onlyProductOwner(msg.sender) {
        Product storage product = idToProduct[_productId];
        product.owner = _newOwner;

        registerNewOwner(_productId, _newOwner);

        emit ProductUpdated(
            _productId,
            product.serialNumber,
            product.designation,
            product.description,
            product.pictureHash,
            product.price,
            _newOwner
        );
    }

    // Modifiers
    modifier onlyProductOwner(address _owner) {
        require(
            _owner == msg.sender,
            "Only product owner can perform this action"
        );
        _;
    }
}

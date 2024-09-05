// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

enum UserRole {
    Admin,
    Validator,
    User
}

enum ProductStatus {
    Undefined,
    Pending,
    Validated,
    Refused
}

struct User {
    // uint256 id;
    string username;
    string avatar;
    UserRole role;
    uint256 createdAt;
}

struct Validation {
    uint id;
    ProductStatus status;
    address validator;
}

struct Product {
    uint id;
    string serialNumber;
    string designation;
    string description;
    string pictureHash; // Hash from IPFS
    uint256 price;
    uint256 registrationDate;
    // uint256 updatedAt;
    address manufacturer;
    address owner;
    ProductStatus status;
    address[] owners;
    uint acceptedValidationsCount;
    uint refusedValidationsCount;
}

struct Report {
    uint id;
    string serialNumber;
    address reporter;
    string details;
    uint256 reportDate;
}

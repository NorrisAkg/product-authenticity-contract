// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./../../src/interfaces/IUserManagement.sol";

abstract contract MockUserManagement is IUserManagement {
    function registerUser() public virtual;
}

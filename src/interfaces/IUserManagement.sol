// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {UserRole} from "./../abstract/Types.sol";

interface IUserManagement {
    function registerUser(
        address _address,
        string memory _username,
        string memory _avatar
    ) external;

    function addAdmin(
        address _address,
        string memory _username,
        string memory _avatar
    ) external;

    function addValidator(
        address _address,
        string memory _username,
        string memory _avatar
    ) external;

    function showUserInfos(
        address _address
    )
        external
        view
        returns (address, string memory, string memory, UserRole role);

    function getAdmins() external view returns (address[] memory);

    function getValidators() external view returns (address[] memory);

    function checkIfUserIsRegistered(
        address _address
    ) external view returns (bool);

    function getUserRole(address _address) external view returns (UserRole);
}

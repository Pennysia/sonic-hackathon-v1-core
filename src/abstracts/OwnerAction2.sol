// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.30;

import {GlobalStorage} from "./GlobalStorage.sol";
import {IAaveV4Handler} from "../interfaces/IAaveV4Handler.sol";
import {PairLibrary} from "../libraries/PairLibrary.sol";
import {Validation} from "../libraries/Validation.sol";
import {TransferHelper} from "../libraries/TransferHelper.sol";

abstract contract OwnerAction2 is GlobalStorage {
    error excessiveSweep();
    address public owner;
    address public facade;

    /// @notice Emitted when excess tokens are swept.
    /// @param sender Caller (owner).
    /// @param to Recipients.
    /// @param tokens Tokens swept.
    /// @param amounts Amounts swept.
    event Sweep(address indexed sender, address[] to, address[] tokens, uint256[] amounts);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function setFacade(address _facade) public onlyOwner {
        facade = _facade;
    }

    function turnDeployerSwitch(address token0, address token1, bool turnOn) public onlyOwner {
        pools[token0][token1].deployerSwitch = turnOn ? uint8(1) : uint8(2);
    }

    function turnAaveSwitch(address token, bool turnOn) public onlyOwner {
        if (turnOn) {
            require(assets[token].aaveReserveId != 0 && assets[token].spokeAddress != address(0), "not initialized");
            assets[token].aaveSwitch = uint8(1);
        } else {
            assets[token].aaveSwitch = uint8(2);
        }
    }

    function configAave(address token, address spoke, uint256 reserveId) public onlyOwner {
        require(getAaveDeposit(token) == 0, "deposit exists");
        assets[token].spokeAddress = spoke;
        assets[token].aaveReserveId = uint88(reserveId);
    }

    function withdrawAave(address token, uint256 amount) public onlyOwner returns (uint256 withdrawn) {
        if (amount == type(uint256).max) amount = getAaveDeposit(token);
        (, withdrawn) =
            IAaveV4Handler(assets[token].spokeAddress).withdraw(assets[token].aaveReserveId, amount, address(this));
        assets[token].holdingBalance += uint128(withdrawn);
    }

    function depositAave(address token, uint256 amount) public onlyOwner returns (uint256 deposited) {
        AssetInfo storage _asset = assets[token];
        require(_asset.aaveSwitch == uint8(1), "not enabled");
        if (amount == type(uint256).max) amount = _asset.holdingBalance;
        (, deposited) = IAaveV4Handler(_asset.spokeAddress).supply(_asset.aaveReserveId, amount, address(this));
        _asset.holdingBalance -= uint128(deposited);
    }

    function sweep(address[] calldata tokens, uint256[] calldata amounts, address[] calldata to) public onlyOwner {
        uint256 length = tokens.length;
        Validation.equalLengths(length, amounts.length);
        Validation.equalLengths(length, to.length);
        for (uint256 i; i < length; i++) {
            require(amounts[i] <= getSweepable(tokens[i]), excessiveSweep());
            TransferHelper.safeTransfer(tokens[i], to[i], amounts[i]);
        }
        emit Sweep(msg.sender, to, tokens, amounts);
    }

    // ------ READ-ONLY ------

    function getBalance(address token) public view returns (uint256 balance) {
        balance = assets[token].holdingBalance + getAaveDeposit(token);
    }

    function getAaveDeposit(address token) public view returns (uint256 deposit) {
        deposit = IAaveV4Handler(assets[token].spokeAddress)
            .getUserSuppliedAssets(assets[token].aaveReserveId, address(this));
    }

    function getAaveShare(address token) public view returns (uint256 share) {
        share = IAaveV4Handler(assets[token].spokeAddress)
            .getUserSuppliedShares(assets[token].aaveReserveId, address(this));
    }

    function getSweepable(address token) public view returns (uint256 amount) {
        return PairLibrary.getBalance(token) - getBalance(token);
    }
}


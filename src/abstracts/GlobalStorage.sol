// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.30;

abstract contract GlobalStorage {
    struct AssetInfo {
        // --- total supply of share
        uint128 totalShare;
        // --- balance held in this contract
        uint128 holdingBalance;
        // --- aave
        uint8 aaveSwitch;
        uint88 aaveReserveId;
        address spokeAddress;
    }

    struct PoolInfo {
        // --- reserve shares
        uint128 share0Long;
        uint128 share0Short;
        uint128 share1Long;
        uint128 share1Short;
        // --- oracle
        uint256 cbrtPriceCumulativeLast; // cum. of (cbrt(y/x * uint128.max))*timeElapsed
        uint32 blockTimestampLast;
        // --- id
        uint56 poolId;
        // --- deployer incentive
        uint8 deployerSwitch;
        address deployer;
        uint128 deployerFee0;
        uint128 deployerFee1;
    }

    mapping(address token => AssetInfo) public assets;
    mapping(address token0 => mapping(address token1 => PoolInfo)) public pools;
}

//1.function quoteSwap
//2.function quoteLiquidity
//3.function quoteReserve
//4.function getAmountsOut (might be redundant to quoteSwap)
//5.function getPriceX128

//-----EXAMPLE FUNCTIONS-----
//---------------------------
//     function quoteLiquidity(
//     address token0,
//     address token1,
//     uint256 amountLong0,
//     uint256 amountShort0,
//     uint256 amountLong1,
//     uint256 amountShort1
// ) public view override returns (uint256 longX, uint256 shortX, uint256 longY, uint256 shortY) {
//     return
//         RouterLibrary.quoteLiquidity(market, token0, token1, amountLong0, amountShort0, amountLong1, amountShort1);
// }

// function quoteReserve(address token0, address token1, uint256 longX, uint256 shortX, uint256 longY, uint256 shortY)
//     public
//     view
//     override
//     returns (uint256 amountLong0, uint256 amountShort0, uint256 amountLong1, uint256 amountShort1)
// {
//     return RouterLibrary.quoteReserve(market, token0, token1, longX, shortX, longY, shortY);
// }

//     function getAmountsOut(uint256 amountIn, address[] calldata path)
//     public
//     view
//     override
//     returns (uint256[] memory amounts)
// {
//     return RouterLibrary.getAmountsOut(market, amountIn, path);
// }

//--------------------------------- Read-Only Functions ---------------------------------
// function getTokenId(uint256 pairId) public pure returns (uint256 idLong, uint256 idShort) {
//     idShort = pairId * 2;
//     idLong = idShort - 1;
// }

// function getReserves(uint256 pairId)
//     public
//     view
//     override
//     returns (uint128 reserve0Long, uint128 reserve1Long, uint128 reserve0Short, uint128 reserve1Short)
// {
//     reserve0Long = pairs[pairId].reserve0Long;
//     reserve1Long = pairs[pairId].reserve1Long;
//     reserve0Short = pairs[pairId].reserve0Short;
//     reserve1Short = pairs[pairId].reserve1Short;
// }

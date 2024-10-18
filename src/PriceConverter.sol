// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// libraries cannot have state variables
library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Address ETH/USD 0x694AA1769357215DE4FAC081bf1f309aDC325306
        (, int256 price,,,) = priceFeed.latestRoundData();
        // Price of eth in terms of USD
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // 1eth
        // 2000_00000000
        uint256 ethPrice = getPrice(priceFeed);
        // always want to multiply before divide
        // whole number works not possible for decimal places
        // 18 zeroes of ethPrice and 18 of eth amount and then we divide by 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        // version function at this address
        // functions of this aggregatorV3interface instance
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
